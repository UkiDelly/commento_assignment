import 'package:commento_assignment/bloc/feed/feed_repository.dart';

import '../../screens/detail/widgets/change_order_widget.dart';

sealed class FeedDetailEvent {}

class FeedDetailInitialEvent extends FeedDetailEvent {
  FeedDetailInitialEvent({
    required this.feedRepository,
  });
  final FeedRepository feedRepository;
}

final class FeedDetailLoadingEvent extends FeedDetailEvent {}


class FeedDetailChangeOrderEvent extends FeedDetailEvent {
  FeedDetailChangeOrderEvent(this.order);
  final FeedDetailOrder order;
}

final class FeedDetailLoadEvent extends FeedDetailEvent {
  FeedDetailLoadEvent(this.id);
  final int id;
}
