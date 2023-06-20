import 'package:commento_assignment/screens/feed/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/feed/feed_cubit.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 670),
      builder: (context, child) => MaterialApp(
        home: MultiBlocProvider(
          providers: [
            // FeedCubit 등록
            BlocProvider<FeedCubit>(create: (_) => FeedCubit()),
          ],
          child: const FeedScreen(),
        ),
      ),
    );
  }
}
