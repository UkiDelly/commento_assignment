import 'package:commento_assignment/bloc/detail/detail_state.dart';
import 'package:commento_assignment/common/colors.dart';
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

    
    // Stateful Widget에서는 initState과 같은 동작
    // [] 안에 들어가는 값이 바뀔때마다 useEffect가 실행되지만 비어 있을경우 한번만 실행
    useEffect(() {
      context.read<FeedDetailBloc>().add(FeedDetailInitialEvent(feedRepository: repository));
      context.read<FeedDetailBloc>().add(FeedDetailLoadEvent(id));

      return () {};
    }, []);

    // id가 바뀔때마다 LoadingEvent를 발생시켜서 이전의 데이터가 안보이게 처리
    // Stateful Widget에서는 initState에서 처리했지만, HookWidget에서는 useEffect를 사용해야함
    useEffect(() {
      context.read<FeedDetailBloc>().add(FeedDetailLoadingEvent());
      return () {};
    }, [id]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: switch (feedDetailBloc) {
            FeedDetailLoadingState() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            FeedDetailErrorState() => Center(
                child: Text(feedDetailBloc.message),
              ),
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
                        Text(
                          "답변 ${feedDetailBloc.feedDetail.reply.length}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        //
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),

                  //
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
