part of 'feed_bloc.dart';

sealed class FeedEvent {}

final class FeedInitial extends FeedEvent {
  FeedInitial({required this.page, required this.feedRepository});
  int page;
  FeedRepository feedRepository;
}

final class FeedOrderChanged extends FeedEvent {
  FeedOrderChanged(this.orderType);

  final OrderType orderType;
}

final class FeedCategoryChanged extends FeedEvent {
  FeedCategoryChanged(this.category);
  final List<CategoryModel> category;
}

final class FeedLoadMoreData extends FeedEvent {
  FeedLoadMoreData(this.page);
  final int page;
}

class FeedSearchEvent extends FeedEvent {
  FeedSearchEvent(this.keyword);
  final String keyword;
}
