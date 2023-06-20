import 'package:commento_assignment/models/ad_model.dart';
import 'package:commento_assignment/models/feed_detail_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'category_model.dart';
import 'feed_model.dart';

part 'response_model.g.dart';

abstract class _BaseResponseModel<T> {
  final T data;
  _BaseResponseModel({
    required this.data,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryResponseModel {
  CategoryResponseModel({
    required this.category,
  });

  final List<CategoryModel> category;

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseModelFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedResponseModel extends _BaseResponseModel<List<FeedModel>> {
  FeedResponseModel({
    required this.currentPage,
    required List<FeedModel> data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  }) : super(data: data);

  final int currentPage;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<dynamic> links;
  final String nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  factory FeedResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseModelFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedDetailResponseModel extends _BaseResponseModel<FeedModel> {
  FeedDetailResponseModel({
    required FeedDetailModel data,
  }) : super(data: data);

  factory FeedDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FeedDetailResponseModelFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdResponseModel extends _BaseResponseModel<List<AdModel>> {
  AdResponseModel({
    required this.currentPage,
    required List<AdModel> data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  }) : super(data: data);

  final int currentPage;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<dynamic> links;
  final String nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  factory AdResponseModel.fromJson(Map<String, dynamic> json) => _$AdResponseModelFromJson(json);
}
