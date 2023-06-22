import 'package:commento_assignment/bloc/feed/feed_bloc.dart';
import 'package:commento_assignment/screens/feed/widgets/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/feed/feed_repository.dart';
import '../../bloc/feed/feed_state.dart';
import 'widgets/feed_filters_widget.dart';

class FeedScreen extends HookWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FeedRepository를 가져온다.
    final repository = context.watch<FeedRepository>();

    // FeedBloc을 초기화한다.
    useEffect(() {
      context.read<FeedBloc>().add(FeedInitial(page: 1, feedRepository: repository));
      return;
    }, const []);

    // FeedPage를 관리하는 state
    final feedPage = useState<int>(1);

    // ScrollConteroller 초기화
    final scrollController = useScrollController();

    // isLoadingMore를 관리하는 state
    final isLoadingMore = useState<bool>(false);

    // FeedBloc의 state를 가져온다.
    final feedState = context.watch<FeedBloc>().state;

    // ScrollController의 offset이 maxScrollExtent - 500에 도달하면 FeedLoadMoreData event를 발생시킨다.
    scrollController.addListener(() async {
      if (scrollController.offset >= scrollController.position.maxScrollExtent - 500) {
        // 이미 로딩 중이라면 return
        if (isLoadingMore.value) {
          return;
        }

        // page를 1 증가
        feedPage.value++;

        // 로딩 중이라고 표시
        isLoadingMore.value = true;

        // FeedLoadMoreData event 발생
        context.read<FeedBloc>().add(FeedLoadMoreData(feedPage.value));

        // 로딩 완료
        isLoadingMore.value = false;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: 375.w,
          height: 670.h,
          child: Column(
            children: [
              FeedFilterWidget(
                onTapSelectCategory: () {
                  scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
              ),
              Expanded(
                // Dart 3.0의 switch expression을 사용해서 FeedState에 따라서 다른 UI를 보여준다.
                child: switch (feedState) {
                  FeedLoading() => const Center(child: CircularProgressIndicator.adaptive()),
                  FeedError() => Center(child: Text((feedState).message)),
                  FeedData() => ListView.builder(
                      controller: scrollController,
                      itemCount: (feedState).feeds.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // index가 4의 배수일 때마다 AdCard를 끼워넣는다.
                        if (index % 4 == 0 && index != 0) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Column(
                              children: [
                                // 광고 카드
                                FeedAdCard((feedState).ads.data[index ~/ 4]),

                                //
                                SizedBox(height: 10.h),

                                // 피드 카드
                                FeedCard((feedState).feeds.data[index]),
                              ],
                            ),
                          );
                        }

                        // 피드 카드
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: FeedCard((feedState).feeds.data[index]),
                        );
                      },
                    ),
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
