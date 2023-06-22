import 'package:commento_assignment/common/dio_client.dart';
import 'package:commento_assignment/models/response_model.dart';
import 'package:commento_assignment/screens/detail/widgets/change_order_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/api.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class FeedDetailBloc extends Bloc<FeedDetailEvent, FeedDetailState> {
  FeedDetailBloc() : super(FeedDetailLoadingState()) {
    // 초기화
    on<FeedDetailInitialEvent>((event, emit) async {
      // event에서 받아온 feedRepository를 _feedRepository에 저장
      // _feedRepository = event.feedRepository;

      // final categoryList = await _feedRepository!.fetchCategory().last;
      // _categoryList.addAll(categoryList);
    });

    // 로딩 이벤트 발생시 Loa
    on<FeedDetailLoadingEvent>((event, emit) {
      emit(FeedDetailLoadingState());
    });

    on<FeedDetailLoadEvent>((event, emit) async {
      final state = await _fetchData(event.id);
      emit(state);
    });

    on<FeedDetailChangeOrderEvent>((event, emit) {
      _changeOrder(event.order);
      emit(state);
    });
  }

  // FeedRepository? _feedRepository;
  // final List<CategoryModel> _categoryList = [];

  Future<FeedDetailState> _fetchData(int id) async {
    try {
      final response = await FeedDio.dio.get(Api.view, queryParameters: {'id': id});
      final responseModel = FeedDetailResponseModel.fromJson(response.data);
      return FeedDetailData(feedDetail: responseModel.data);
    } catch (e) {
      return FeedDetailErrorState(message: e.toString());
    }
  }

  void _changeOrder(FeedDetailOrder orderType) {
    if (orderType == FeedDetailOrder.oldest) {
      // sort the state.feedDetail.reply from latest to oldest
      (state as FeedDetailData).feedDetail.reply.sort((a, b) => a.id.compareTo(b.id));
    } else {
      // sort the state.feedDetail.reply from oldest to latest
      (state as FeedDetailData).feedDetail.reply.sort((a, b) => b.id.compareTo(a.id));
    }
  }
}
