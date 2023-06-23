import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class FeedDio {
  static Dio get dio => Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASEURL']!,
          headers: {'Accept': Headers.jsonContentType},
        ),
      );
}
