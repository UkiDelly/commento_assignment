import 'package:commento_assignment/bloc/feed/feed_repository.dart';
import 'package:commento_assignment/common/theme.dart';
import 'package:commento_assignment/screens/feed/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/detail/detail_bloc.dart';
import 'bloc/feed/feed_bloc.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await ScreenUtil.ensureScreenSize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 670),
      useInheritedMediaQuery: true,
      builder: (context, child) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<FeedRepository>(
            create: (context) => FeedRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            // FeedBloc 등록
            BlocProvider<FeedBloc>(
              create: (context) => FeedBloc(),
            ),

            // FeedDetailBloc 등록
            BlocProvider(create: (context) => FeedDetailBloc()),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const FeedScreen(),
          ),
        ),
      ),
    );
  }
}
