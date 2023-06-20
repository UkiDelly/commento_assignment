// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedDetailModel _$FeedDetailModelFromJson(Map<String, dynamic> json) =>
    FeedDetailModel(
      id: json['id'] as int,
      title: json['title'] as String,
      contents: json['contents'] as String,
      categoryId: json['category_id'] as int,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      category:
          CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      reply: (json['reply'] as List<dynamic>)
          .map((e) => FeedReplyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedDetailModelToJson(FeedDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'contents': instance.contents,
      'category_id': instance.categoryId,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'category': instance.category,
      'reply': instance.reply,
      'user': instance.user,
    };
