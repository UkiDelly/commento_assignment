import 'package:commento_assignment/common/api.dart';
import 'package:commento_assignment/common/dio_client.dart';
import 'package:commento_assignment/models/ad_model.dart';
import 'package:commento_assignment/models/feed_model.dart';
import 'package:commento_assignment/models/response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/category_model.dart';

enum OrderType {
  asc("오름차순"),
  desc("내림차순");

  final String name;
  const OrderType(this.name);
}

sealed class FeedState {}

final class FeedLoading extends FeedState {}

final class FeedError extends FeedState {
  FeedError(this.message);

  final String message;

  @override
  String toString() => 'FeedError(message: $message)';
}

class FeedData extends FeedState {
  FeedData({
    required this.feeds,
    required this.ads,
    required this.category,
    this.orderType = OrderType.asc,
  });

  final List<FeedModel> feeds;
  final List<AdModel> ads;
  final List<CategoryModel> category;
  final OrderType orderType;

  @override
  String toString() {
    return 'FeedData(feeds: $feeds, ads: $ads, category: $category, orderType: $orderType)';
  }

  FeedData copyWith({
    List<FeedModel>? feeds,
    List<AdModel>? ads,
    List<CategoryModel>? category,
    OrderType? orderType,
  }) {
    return FeedData(
      feeds: feeds ?? this.feeds,
      ads: ads ?? this.ads,
      category: category ?? this.category,
      orderType: orderType ?? this.orderType,
    );
  }
}

class FeedNotifier extends ChangeNotifier {
  FeedNotifier();

  FeedState _state = FeedLoading();
  FeedState get state => _state;

  List<CategoryModel> _category = [];
  // 외부에서 값을 가져갈 수 있도록 getter를 만들어줍니다.
  List<CategoryModel> get category => _category;

  int _lastPage = 0;

  /// [fetchCategory] 서버에서 카테고리 데이터를 받아오는 함수.
  Future<List<CategoryModel>> fetchCategory() async {
    try {
      final response = await FeedDio.dio.get(Api.category);
      final categoryList = CategoryResponseModel.fromJson(response.data).category;
      _category = categoryList;
      return categoryList;
    } on DioException catch (e) {
      _state = FeedError(e.message!);
      return [];
    } finally {
      notifyListeners();
    }
  }

  /// [fetchAds] 서버에서 광고 데이터를 받아오는 함수.
  Future<List<AdModel>> fetchAds(int page) async {
    try {
      final response = await FeedDio.dio.get('/ads', queryParameters: {'page': page, 'limit': 10});

      final adList = AdResponseModel.fromJson(response.data).data;

      return adList;
    } on DioException catch (e) {
      _state = FeedError(e.message!);
      return [];
    } finally {
      notifyListeners();
    }
  }

  /// [fetchFeed] 서버에서 피드 데이터를 받아오는 함수.
  /// [page] 피드 데이터의 페이지.
  Future<void> fetchFeed() async {
    await fetchCategory();
    final ads = await fetchAds(1);

    try {
      final response = await FeedDio.dio.get(
        Api.list,
        queryParameters: {
          'page': 1,
          'limit': 10,
          'ord': describeEnum(OrderType.asc),
          for (int i = 0; i < _category.length; i++) 'category[$i]': _category[i].id.toString(),
        },
      );

      final feedData = FeedResponseModel.fromJson(response.data);

      // 마지막 페이지를 저장해둔다.
      _lastPage = feedData.lastPage;

      // state를 업데이트한다.
      _state = FeedData(feeds: feedData.data, ads: ads, category: _category);
    } on DioException catch (e) {
      _state = FeedError(e.message!);
    } finally {
      notifyListeners();
    }
  }

  /// [fetchMoreFeed] 서버에서 피드 데이터를 받아오는 함수.
  /// [page] 피드 데이터의 페이지.
  Future<void> fetchMoreFeed(int page) async {
    if (page > _lastPage) {
      return;
    }

    final ads = await fetchAds(page);

    try {
      final response = await FeedDio.dio.get(
        Api.list,
        queryParameters: {
          'page': page,
          'limit': 10,
          'ord': describeEnum((_state as FeedData).orderType),
          for (int i = 0; i < (_state as FeedData).category.length; i++)
            'category[$i]': (_state as FeedData).category[i].id.toString(),
        },
      );

      final feedData = FeedResponseModel.fromJson(response.data);

      // 마지막 페이지를 저장해둔다.
      _lastPage = feedData.lastPage;

      // state를 업데이트한다.
      _state = (_state as FeedData).copyWith(
        feeds: [...(_state as FeedData).feeds, ...feedData.data],
        ads: [...(_state as FeedData).ads, ...ads],
      );
    } on DioException catch (e) {
      _state = FeedError(e.message!);
    } finally {
      notifyListeners();
    }
  }

  /// [changeOrder] 현재 피드 데이터의 정렬 순서를 변경하는 함수.
  void changeOrder(OrderType orderType) async {
    _state = FeedLoading();
    notifyListeners();

    final ads = await fetchAds(1);

    try {
      final response = await FeedDio.dio.get(
        Api.list,
        queryParameters: {
          'page': 1,
          'limit': 10,
          'ord': describeEnum(orderType),
          for (int i = 0; i < _category.length; i++) 'category[$i]': _category[i].id.toString(),
        },
      );

      final feedData = FeedResponseModel.fromJson(response.data);

      // 마지막 페이지를 저장해둔다.
      _lastPage = feedData.lastPage;

      // state를 업데이트한다.
      _state = FeedData(feeds: feedData.data, ads: ads, category: _category, orderType: orderType);
    } on DioException catch (e) {
      _state = FeedError(e.message!);
    } finally {
      notifyListeners();
    }
  }

  /// [findCategory] 카테고리 아이디로 카테고리를 찾는 함수.
  /// [id] 카테고리 아이디.
  CategoryModel findCategory(int id) {
    return _category.firstWhere((element) => element.id == id);
  }

  void changeCategory(List<CategoryModel> category) {
    _state = (_state as FeedData).copyWith(category: category);
  }
}
