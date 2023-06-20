import 'package:json_annotation/json_annotation.dart';

part 'feed_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedModel {
  FeedModel({
    required this.id,
    required this.title,
    required this.contents,
    required this.categoryId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String contents;
  final int categoryId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory FeedModel.fromJson(Map<String, dynamic> json) => _$FeedModelFromJson(json);

  @override
  String toString() {
    return 'FeedModel(id: $id, title: $title, contents: $contents, categoryId: $categoryId, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
