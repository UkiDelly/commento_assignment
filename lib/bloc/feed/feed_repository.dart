import 'package:commento_assignment/common/dio_client.dart';
import 'package:commento_assignment/models/category_model.dart';
import 'package:commento_assignment/models/response_model.dart';
import 'package:dio/dio.dart';

import '../../common/api.dart';

class FeedRepository {
  Stream<List<CategoryModel>> fetchCategory() async* {
    try {
      final response = await FeedDio.dio.get(Api.category);
      yield CategoryResponseModel.fromJson(response.data).category;
    } on DioException {
      yield [];
    }
  }
}
