import 'package:commento_assignment/models/feed_detail_model.dart';

sealed class FeedDetailState {}

final class FeedDetailLoadingState extends FeedDetailState {}

class FeedDetailErrorState extends FeedDetailState {
  FeedDetailErrorState({
    required this.message,
  });

  final String message;

  @override
  String toString() => 'DetailError(message: $message)';
}

class FeedDetailData extends FeedDetailState {
  FeedDetailData({
    required this.feedDetail,
  });

  final FeedDetailModel feedDetail;

  @override
  String toString() => 'DetailData(feedDetail: $feedDetail)';
}
