import 'package:json_annotation/json_annotation.dart';

part 'ad_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class AdModel {
  AdModel({
    required this.id,
    required this.title,
    required this.contents,
    required this.img,
    required this.createdAt,
    required this.updatedAt,
  });
  final int id;
  final String title;
  final String contents;
  final String img;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory AdModel.fromJson(Map<String, dynamic> json) => _$AdModelFromJson(json);
}
