part of 'feed_bloc.dart';

sealed class FeedEvent {}

final class FeedInitial extends FeedEvent {
  FeedInitial(this.page, this.feedRepository);
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
