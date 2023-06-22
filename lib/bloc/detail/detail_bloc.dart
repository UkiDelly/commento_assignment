import 'package:commento_assignment/bloc/feed/feed_repository.dart';
import 'package:commento_assignment/common/dio_client.dart';
import 'package:commento_assignment/models/category_model.dart';
import 'package:commento_assignment/models/response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/api.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class FeedDetailBloc extends Bloc<FeedDetailEvent, FeedDetailState> {
  FeedDetailBloc() : super(FeedDetailLoadingState()) {
    on<FeedDetailInitialEvent>((event, emit) async {
      _feedRepository = event.feedRepository;

      final categoryList = await _feedRepository!.fetchCategory().last;
      _categoryList.addAll(categoryList);
    });

    on<FeedDetailLoadingEvent>((event, emit) {
      emit(FeedDetailLoadingState());
    });

    on<FeedDetailLoadEvent>((event, emit) async {
      final state = await _fetchData(event.id);
      emit(state);
    });

    on<FeedDetailDisposeEvent>((event, emit) {
      emit(FeedDetailLoadingState());
    });
  }

  FeedRepository? _feedRepository;
  final List<CategoryModel> _categoryList = [];

  Future<FeedDetailState> _fetchData(int id) async {
    try {
      final response = await FeedDio.dio.get(Api.view, queryParameters: {'id': id});
      final responseModel = FeedDetailResponseModel.fromJson(response.data);
      return FeedDetailData(feedDetail: responseModel.data);
    } catch (e) {
      return FeedDetailErrorState(message: e.toString());
    }
  }
}
