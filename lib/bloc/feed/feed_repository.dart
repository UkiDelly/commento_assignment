import 'package:commento_assignment/common/dio_client.dart';
import 'package:commento_assignment/models/category_model.dart';
import 'package:commento_assignment/models/response_model.dart';
import 'package:dio/dio.dart';

import '../../common/api.dart';

class FeedRepository {
  /// [fetchCategory] - 카테고리 데이터를 받는 함수
  Future<List<CategoryModel>> fetchCategory() async {
    try {
      final response = await FeedDio.dio.get(Api.category);
      return CategoryResponseModel.fromJson(response.data).category;
    } on DioException {
      return [];
    }
  }
}
