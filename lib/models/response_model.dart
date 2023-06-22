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
    this.nextPageUrl,
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
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  factory FeedResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseModelFromJson(json);

  FeedResponseModel copyWith({
    List<FeedModel>? data,
    int? currentPage,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<dynamic>? links,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) {
    return FeedResponseModel(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      firstPageUrl: firstPageUrl ?? this.firstPageUrl,
      from: from ?? this.from,
      lastPage: lastPage ?? this.lastPage,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      links: links ?? this.links,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      path: path ?? this.path,
      perPage: perPage ?? this.perPage,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      to: to ?? this.to,
      total: total ?? this.total,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedDetailResponseModel extends _BaseResponseModel<FeedDetailModel> {
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
    this.nextPageUrl,
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
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  factory AdResponseModel.fromJson(Map<String, dynamic> json) => _$AdResponseModelFromJson(json);

  AdResponseModel copyWith({
    List<AdModel>? data,
    int? currentPage,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<dynamic>? links,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) {
    return AdResponseModel(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      firstPageUrl: firstPageUrl ?? this.firstPageUrl,
      from: from ?? this.from,
      lastPage: lastPage ?? this.lastPage,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      links: links ?? this.links,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      path: path ?? this.path,
      perPage: perPage ?? this.perPage,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      to: to ?? this.to,
      total: total ?? this.total,
    );
  }
}
