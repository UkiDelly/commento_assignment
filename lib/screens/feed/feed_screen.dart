import 'package:commento_assignment/provider/feed_provider.dart';
import 'package:commento_assignment/screens/feed/widgets/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

import 'widgets/feed_filters_widget.dart';

class FeedScreen extends HookWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feedPage = useState<int>(1);
    final scrollController = useScrollController();
    final isLoadingMore = useState<bool>(false);
    final feedState = context.watch<FeedNotifier>().state;

    scrollController.addListener(() async {
      if (scrollController.offset >= scrollController.position.maxScrollExtent - 500) {
        if (isLoadingMore.value) {
          return;
        }

        feedPage.value++;
        isLoadingMore.value = true;
        await context.read<FeedNotifier>().fetchMoreFeed(feedPage.value);
        isLoadingMore.value = false;
      }
    });

    useEffect(() {
      context.read<FeedNotifier>().fetchFeed();
      return;
    }, []);

    Logger().d(feedState);

    // Dart 3.0의 switch expression을 사용해서 FeedState에 따라서 다른 UI를 보여준다.
    final ui = switch (feedState) {
      FeedLoading() => const Center(child: CircularProgressIndicator.adaptive()),
      FeedError() => Center(child: Text((feedState).message)),
      FeedData() => ListView.builder(
          controller: scrollController,
          itemCount: (feedState).feeds.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // index가 4의 배수일 때마다 AdCard를 끼워넣는다.
            if (index % 4 == 0 && index != 0) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Column(
                  children: [
                    // 광고 카드
                    FeedAdCard((feedState).ads[index ~/ 4]),

                    //
                    SizedBox(height: 10.h),

                    // 피드 카드
                    FeedCard((feedState).feeds[index]),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: FeedCard((feedState).feeds[index]),
            );
          },
        ),
    };

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          FeedFilterWidget(
            onTapSelectCategory: () {
              scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
            },
          ),
          Expanded(
            child: ui,
          )
        ],
      ),
    ));

    // final feedBloc = context.watch<FeedBloc>();
    // final scrollController = useScrollController();
    // final page = useState<int>(1);
    // final isLoadingMore = useState<bool>(false);
    // useEffect(() {
    //   context.read<FeedBloc>().add(FeedInitial(page.value));
    //   page.value++;
    //   return null;
    // }, const []);

    // scrollController.addListener(() async {
    //   if (scrollController.offset >= scrollController.position.maxScrollExtent - 500) {
    //     if (isLoadingMore.value) {
    //       return;
    //     }
    //     isLoadingMore.value = true;

    //     context.read<FeedBloc>().add(FeedLoadMoreData(page.value));
    //     page.value++;
    //     isLoadingMore.value = false;
    //   }
    // });

    // final ui = switch (feedBloc.state) {
    //   FeedLoading() => const Center(child: CircularProgressIndicator.adaptive()),
    //   FeedError() => Center(child: Text((feedBloc.state as FeedError).message)),
    //   FeedData() => ListView.builder(
    //       controller: scrollController,
    //       itemCount: (feedBloc.state as FeedData).feeds.data.length,
    //       shrinkWrap: true,
    //       itemBuilder: (context, index) {
    //         // index가 4의 배수일 때마다 AdCard를 끼워넣는다.
    //         if (index % 4 == 0 && index != 0) {
    //           return Padding(
    //             padding: EdgeInsets.only(bottom: 10.h),
    //             child: FeedAdCard((feedBloc.state as FeedData).ads.data[index ~/ 4]),
    //           );
    //         }

    //         return Padding(
    //           padding: EdgeInsets.only(bottom: 10.h),
    //           child: FeedCard((feedBloc.state as FeedData).feeds.data[index]),
    //         );
    //       },
    //     ),
    // };

    // return Scaffold(
    //   body: SafeArea(
    //     child: Column(
    //       children: [
    //         const FeedFilterWidget(),
    //         Divider(
    //           height: 1.h,
    //         ),
    //         Expanded(
    //           child: ui,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
