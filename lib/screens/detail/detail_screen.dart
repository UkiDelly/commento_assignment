import 'package:commento_assignment/bloc/detail/detail_state.dart';
import 'package:commento_assignment/common/colors.dart';
import 'package:commento_assignment/screens/detail/widgets/change_order_widget.dart';
import 'package:commento_assignment/screens/detail/widgets/reply_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../bloc/detail/detail_bloc.dart';
import '../../bloc/detail/detail_event.dart';
import '../../bloc/feed/feed_repository.dart';

class DetailScreen extends HookWidget {
  const DetailScreen(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final repository = context.watch<FeedRepository>();
    final feedDetailBloc = context.watch<FeedDetailBloc>().state;

    // Stateful Widget에서는 didChangeDependencies과 같은 동작을 실행,
    // 하지만 []이 비어있으면 한번만 실행 initState와 같은 동작
    useEffect(() {
      context.read<FeedDetailBloc>().add(FeedDetailInitialEvent(feedRepository: repository));

      return () {};
    }, []);

    // id가 바뀔때마다 LoadingEvent를 발생시켜서 FeedDetailState을 FeedLoadingState으로 변경 처리후 다시 FeedLoadEvent를 발생시켜서 데이터를 가져옴
    useEffect(() {
      context.read<FeedDetailBloc>().add(FeedDetailLoadingEvent());
      context.read<FeedDetailBloc>().add(FeedDetailLoadEvent(id));
      return () {};
    }, [id]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: switch (feedDetailBloc) {
            // Dart 3.0의 switch expression을 사용하여 FeedDetailState에 따라서 다른 위젯을 반환

            // 로딩 상태
            FeedDetailLoadingState() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),

            // 에러 상태
            FeedDetailErrorState() => Center(
                child: Text(feedDetailBloc.message),
              ),

            // 데이터 상태
            FeedDetailData() => CustomScrollView(
                slivers: [
                  //
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        SizedBox(height: 30.h),

                        //
                        Divider(
                          height: 1.h,
                          color: AppColors.blue,
                          thickness: 1.h,
                        ),

                        //
                        SizedBox(height: 20.h),

                        // 제목
                        Text(feedDetailBloc.feedDetail.title,
                            style: Theme.of(context).textTheme.titleLarge),

                        //
                        SizedBox(height: 7.h),

                        // 내용
                        Text(
                          feedDetailBloc.feedDetail.contents,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        //
                        SizedBox(
                          height: 16.h,
                        ),

                        // 작성 날짜
                        Text(
                          DateFormat("yyyy-MM-dd").format(feedDetailBloc.feedDetail.createdAt),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),

                        //
                        SizedBox(height: 20.h),

                        //
                        Divider(
                          height: 1.h,
                          color: AppColors.blue,
                          thickness: 1.h,
                        ),

                        //
                        SizedBox(height: 31.h),

                        // 댓글 갯수
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //
                            Text(
                              "답변 ${feedDetailBloc.feedDetail.reply.length}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),

                            //
                            const FeedDetailChangeOrderWidget()
                          ],
                        ),

                        //
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),

                  // 답변 리스트
                  SliverList.builder(
                    itemCount: feedDetailBloc.feedDetail.reply.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: (index == feedDetailBloc.feedDetail.reply.length - 1)
                            ? EdgeInsets.zero
                            : EdgeInsets.only(bottom: 30.h),
                        child: ReplyCard(reply: feedDetailBloc.feedDetail.reply[index]),
                      );
                    },
                  )
                ],
              )
          },
        ),
      ),
    );
  }
}
