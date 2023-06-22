import 'package:commento_assignment/models/feed_reply_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({super.key, required this.reply});

  final FeedReplyModel reply;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 201.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1.h),
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.h),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          SizedBox(height: 21.h),

          // 작성자
          Text(
            reply.user.name,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: const Color(0xff7e848a),
                ),
          ),

          //
          SizedBox(height: 10.h),

          //
          Divider(height: 1.h, thickness: 1.h),

          //
          SizedBox(height: 16.h),

          // 내용
          Text(
            reply.contents,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          //
          SizedBox(height: 16.h),

          // 작성일
          Text(
            DateFormat('yyyy-MM-dd').format(reply.createdAt),
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: const Color(0xff7e848a),
                ),
          ),
        ],
      ),
    );
  }
}
