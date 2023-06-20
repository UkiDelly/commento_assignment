import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xfff4f5f7),
    cardColor: Colors.white,
    dividerColor: const Color(0xffE1E4E7),
    disabledColor: const Color(0xffADB5BD),
    fontFamily: 'SpoqaHanSansNeo',
    textTheme: TextTheme(
      // FeedCard의 타이틀
      titleLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xff282c30),
      ),

      // FeedCard의 내용
      titleMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: const Color(0xff405057),
      ),

      // FeedCard의 작성자
      titleSmall: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.normal,
        color: const Color(0xff7e848a),
      ),
    ),
  );
}
