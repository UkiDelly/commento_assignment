// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedReplyModel _$FeedReplyModelFromJson(Map<String, dynamic> json) =>
    FeedReplyModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      parent: json['parent'] as int,
      contents: json['contents'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedReplyModelToJson(FeedReplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'parent': instance.parent,
      'contents': instance.contents,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user,
    };
