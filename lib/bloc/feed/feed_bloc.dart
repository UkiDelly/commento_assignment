import 'package:commento_assignment/bloc/feed/feed_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common/api.dart';
import '../../common/dio_client.dart';
import '../../models/category_model.dart';
import '../../models/response_model.dart';
import 'feed_state.dart';

part 'feed_event.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedLoading()) {
    //* FeedBloc이 생성될 때 FeedInitial Event를 추가합니다.
    on<FeedInitial>((event, emit) async {
      emit(FeedLoading());

      _feedRepository = event.feedRepository;

      // Category 데이터 가져오기
      final categoryList = await _feedRepository!.fetchCategory().last;

      // 필터 선택지로 사용하기 위헤 categoryList를 저장합니다.
      _categoryList.addAll(categoryList);

      // 광고 데이터 가져오기
      final ad = await _fetchAds(1);

      // 피드 데이터 가져오기
      final feedData =
          await _fetchData(page: 1, ad: ad!, orderType: OrderType.asc, categoryList: categoryList);

      // 상태 업데이트
      emit(feedData);
    });

    //* 스크롤이 최하단에 닿았을 때 추가 데이터를 가져오기 위한 Event입니다.
    on<FeedLoadMoreData>((event, emit) async {
      int page = event.page;

      // 마지막 페이지인 경우 추가 데이터를 가져오지 않습니다.
      if (page > (state as FeedData).feeds.lastPage) {
        return;
      } else {
        // 추가 데이터를 가져옵니다.
        final newState = await _fetchMoreData(page);
        if (newState == null) {
          return;
        }

        // orderType에 따라 피드 데이터를 정렬합니다.
        if (newState.orderType == OrderType.asc) {
          newState.feeds.data.sort((a, b) => a.id.compareTo(b.id));
          newState.ads.data.sort((a, b) => a.id.compareTo(b.id));
        } else {
          newState.feeds.data.sort((a, b) => b.id.compareTo(a.id));
          newState.ads.data.sort((a, b) => b.id.compareTo(a.id));
        }

        // 상태를 업데이트합니다.
        emit(newState);
      }
    });

    //* 정렬을 변경하는 Event입니다.
    on<FeedOrderChanged>((event, emit) async {
      final orderType = event.orderType;
      final ads = await _fetchAds(1);

      // 필터를 적용하여 데이터를 가져옵니다.
      final newState = await _fetchData(
          page: 1, ad: ads!, orderType: orderType, categoryList: (state as FeedData).category);

      // 상태 업뎅트
      emit(newState);
    });

    //* 필터를 변경했을 때 Event입니다.
    on<FeedCategoryChanged>((event, emit) async {
      final category = event.category;

      // 필터를 적용하여 데이터를 가져옵니다.
      final newState = await _changeCategory(category);

      // 상태 업뎅트
      emit(newState);
    });
  }

  // FeedRepository를 사용하기 위한 변수입니다.
  FeedRepository? _feedRepository;

  // 필터로 사용하는 categoryList를 저장하기 위한 변수입니다.
  // 외부 접근을 제한하기 위해 private 변수로 선언합니다.
  final List<CategoryModel> _categoryList = [];

  // categoryList를 외부에서 접근하기 위한 getter입니다.
  List<CategoryModel> get categoryList => _categoryList;

  /// [fetchCategory] - Category 데이터를 가져오는 함수입니다. 등록된 Respository를 통해 외부에서 데이터를 주입받습니다.
  Future<List<CategoryModel>> fetchCategory() async {
    try {
      final categoryResponse = await FeedDio.dio.get(Api.category);
      return CategoryResponseModel.fromJson(categoryResponse.data).category;
    } on DioException {
      return [];
    }
  }

  /// [_fetchAds] - Ad 데이터를 가져오는 함수입니다.
  Future<AdResponseModel?> _fetchAds(int adPage) async {
    try {
      // Ad 데이터 가져오기
      final adResponse =
          await FeedDio.dio.get('/ads', queryParameters: {'page': adPage, 'limit': 10});

      return AdResponseModel.fromJson(adResponse.data);
    } on DioException {
      return null;
    }
  }

  /// [_fetchData] - 피드 데이터를 가져오는 함수입니다.
  Future<FeedState> _fetchData({
    required int page,
    required AdResponseModel ad,
    required OrderType orderType,
    required List<CategoryModel> categoryList,
  }) async {
    // Feed 데이터 가져오기
    try {
      //
      final feedReponse = await FeedDio.dio.get(
        Api.list,
        queryParameters: {
          'page': page,
          'limit': 10,
          'ord': describeEnum(orderType),
          for (int i = 0; i < categoryList.length; i++)
            'category[$i]': categoryList[i].id.toString(),
        },
      );

      final feedList = FeedResponseModel.fromJson(feedReponse.data);

      return FeedData(feeds: feedList, orderType: orderType, ads: ad, category: categoryList);
    } on DioException catch (e) {
      Logger().e(e.requestOptions.queryParameters);
      return FeedError(e.toString());
    }
  }

  /// [_fetchMoreDate] 스크롤이 끝에 닿았을 때 추가 데이터를 가져오는 함수입니다.
  Future<FeedData> _fetchMoreData(int page) async {
    // Feed 데이터 가져오기
    final ads = await _fetchAds(page);

    try {
      // Dart 3.0에서 추가된 패턴을 통해 데이터 추출
      var FeedData(:category, :orderType) = state as FeedData;
      final response = await FeedDio.dio.get(Api.list, queryParameters: {
        'page': page,
        'limit': 10,
        'ord': describeEnum(orderType),
        for (int i = 0; i < category.length; i++) 'category[$i]': category[i].id.toString(),
      });

      final feedList = FeedResponseModel.fromJson(response.data).data;

      final prevState = state as FeedData;

      return FeedData(
        feeds: prevState.feeds.copyWith(
          data: [...prevState.feeds.data, ...feedList],
        ),
        ads: prevState.ads.copyWith(
          data: [...prevState.ads.data, ...ads!.data],
        ),
        category: category,
        orderType: orderType,
      );
    } on DioException {
      return state as FeedData;
    }
  }

  /// [findCategory] 함수는 [id]를 받아서 [CategoryModel]을 반환합니다.
  CategoryModel findCategory(int id) {
    return (state as FeedData).category.firstWhere((element) => element.id == id);
  }

  /// [_changeCategory] 함수는 [category]를 받아서 [FeedState]를 반환합니다.
  Future<FeedState> _changeCategory(List<CategoryModel> category) async {
    try {
      // 광고 데이터 가져오기
      final ads = await _fetchAds(1);

      // 기존 피드 데이터 에서 정렬 기준을 가져오기
      final FeedData(:orderType) = state as FeedData;

      /// 추출한 orderType과 event에서 받은 category를 사용하여 데이터를 요청합니다.
      final newState =
          await _fetchData(page: 1, ad: ads!, orderType: orderType, categoryList: category);

      return newState;
    } on DioException {
      return state;
    }
  }

  @override
  void onChange(Change<FeedState> change) {
    Logger().d(change);
    super.onChange(change);
  }
}
