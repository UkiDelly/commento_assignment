import 'package:commento_assignment/models/category_model.dart';
import 'package:commento_assignment/models/feed_reply_model.dart';
import 'package:commento_assignment/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'feed_model.dart';

part 'feed_detail_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedDetailModel extends FeedModel {
  FeedDetailModel({
    required super.id,
    required super.title,
    required super.contents,
    required super.categoryId,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
    required this.category,
    required this.reply,
    required this.user,
  });

  final CategoryModel category;
  final List<FeedReplyModel> reply;
  final User user;

  factory FeedDetailModel.fromJson(Map<String, dynamic> json) => _$FeedDetailModelFromJson(json);

  @override
  String toString() => 'FeedDetailModel(category: $category, reply: $reply, user: $user)';
}
