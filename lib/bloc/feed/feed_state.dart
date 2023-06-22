import '../../models/category_model.dart';
import '../../models/response_model.dart';

enum OrderType {
  asc("오름차순"),
  desc("내림차순");

  final String name;
  const OrderType(this.name);
}

sealed class FeedState {}

class FeedLoading extends FeedState {}

class FeedError extends FeedState {
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
    this.page = 1,
    this.adPage = 1,
    this.orderType = OrderType.asc,
  });

  final FeedResponseModel feeds;
  final AdResponseModel ads;
  final List<CategoryModel> category;
  final int page;
  final int adPage;
  final OrderType orderType;

  @override
  String toString() => 'FeedData(feeds: $feeds, ads: $ads, category: $category)';

  FeedData copyWith({
    FeedResponseModel? feeds,
    AdResponseModel? ads,
    List<CategoryModel>? category,
    int? page,
    int? adPage,
    OrderType? orderType,
  }) {
    return FeedData(
      feeds: feeds ?? this.feeds,
      ads: ads ?? this.ads,
      category: category ?? this.category,
      page: page ?? this.page,
      adPage: adPage ?? this.adPage,
      orderType: orderType ?? this.orderType,
    );
  }
}
