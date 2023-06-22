import 'package:commento_assignment/bloc/feed/feed_repository.dart';

sealed class FeedDetailEvent {}

class FeedDetailInitialEvent extends FeedDetailEvent {
  FeedDetailInitialEvent({
    required this.feedRepository,
  });
  final FeedRepository feedRepository;
}

final class FeedDetailLoadingEvent extends FeedDetailEvent {}

final class FeedDetailDisposeEvent extends FeedDetailEvent {}

final class FeedDetailLoadEvent extends FeedDetailEvent {
  FeedDetailLoadEvent(this.id);
  final int id;
}
