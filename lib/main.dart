import 'package:commento_assignment/common/theme.dart';
import 'package:commento_assignment/provider/feed_provider.dart';
import 'package:commento_assignment/screens/feed/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
        theme: AppTheme.lightTheme,
        home: MultiProvider(providers: [
          ChangeNotifierProvider(
            create: (context) => FeedNotifier(),
            lazy: true,
          )
        ], child: const FeedScreen()
            // MultiBlocProvider(
            //   providers: [
            //     // FeedCubit 등록
            //     BlocProvider<FeedBloc>(create: (_) => FeedBloc()),
            //   ],
            //   child: const FeedScreen(),
            // ),
            ),
      ),
    );
  }
}
