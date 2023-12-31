import 'package:commento_assignment/bloc/feed/feed_bloc.dart';
import 'package:commento_assignment/common/colors.dart';
import 'package:commento_assignment/models/ad_model.dart';
import 'package:commento_assignment/models/feed_model.dart';
import 'package:commento_assignment/screens/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedCard extends HookWidget {
  const FeedCard(this.feedItem, {super.key});

  final FeedModel feedItem;

  @override
  Widget build(BuildContext context) {
    final category = context.read<FeedBloc>().findCategory(feedItem.categoryId);

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DetailScreen(feedItem.id)));
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            SizedBox(height: 21.h),

            //
            Row(
              children: [
                // 카테고리 이름
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: const Color(0xff7e848a),
                      ),
                ),
                const Spacer(),

                // 게시물 id
                Text(
                  feedItem.id.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),

            //
            SizedBox(height: 10.h),

            //
            Divider(
              height: 1.h,
              color: const Color(0xffebebeb),
            ),

            //
            SizedBox(height: 16.h),

            // 유저 id
            Text(
              feedItem.userId.toString(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.userColor,
                  ),
            ),

            //
            SizedBox(height: 16.h),

            // 제목
            Text(
              feedItem.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            //
            SizedBox(height: 6.h),

            // 내용
            Text(
              feedItem.contents,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            //
            SizedBox(height: 20.h)
          ],
        ),
      ),
    );
  }
}

/// 광고 카드
/// [adItem] : 광고 데이터
class FeedAdCard extends HookWidget {
  const FeedAdCard(this.adItem, {super.key});

  final AdModel adItem;

  @override
  Widget build(BuildContext context) {
    final visible = useState<bool>(true);

    return Visibility(
      visible: visible.value,
      child: Container(
        height: 381.h,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            SizedBox(height: 21.h),

            // sponsered 문구
            //* 고객 요청 사항
            //  - 광고 카드 가리기 기능 추가
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                Text("sponsered", style: Theme.of(context).textTheme.titleSmall),

                // 가리기 버튼
                InkWell(
                  onTap: () {
                    visible.value = false;
                  },
                  child: Icon(
                    size: 20.w,
                    Icons.close,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ],
            ),

            //
            SizedBox(height: 16.5.h),

            // 이미지
            Flexible(
              child: Image.network(
                "${dotenv.env['ADIMAGEURL']!}/${adItem.img}",
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),

            //
            SizedBox(height: 16.5.h),

            // 제목
            Text(
              adItem.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            //
            SizedBox(height: 6.h),

            // 내용
            Text(
              adItem.contents,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            //
            SizedBox(height: 20.h)
          ],
        ),
      ),
    );
  }
}
