import 'package:commento_assignment/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../provider/feed_provider.dart';

typedef OnOrderTypeChanged = void Function(OrderType orderType);

class FeedOrderButton extends HookWidget {
  const FeedOrderButton({
    super.key,
    required this.orderType,
    required this.selected,
    required this.onOrderTypeChanged,
  });

  final OrderType orderType;
  final OnOrderTypeChanged onOrderTypeChanged;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: () => onOrderTypeChanged(orderType),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.orderSelectedColor : Theme.of(context).dividerColor,
              ),
            ),

            //
            SizedBox(width: 5.w),

            //
            Text(
              orderType.name,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: selected ? AppColors.userColor : Theme.of(context).disabledColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
