import 'package:commento_assignment/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feed_reply_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedReplyModel {
  FeedReplyModel({
    required this.id,
    required this.userId,
    required this.parent,
    required this.contents,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });
  final int id;
  final int userId;
  final int parent;
  final String contents;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  factory FeedReplyModel.fromJson(Map<String, dynamic> json) => _$FeedReplyModelFromJson(json);
}
