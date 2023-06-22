import 'package:commento_assignment/bloc/feed/feed_bloc.dart';
import 'package:commento_assignment/screens/feed/widgets/feed_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../bloc/feed/feed_state.dart';
import '../../../models/category_model.dart';
import 'feed_order_button.dart';

class FeedFilterWidget extends HookWidget {
  const FeedFilterWidget({Key? key, required this.onTapSelectCategory}) : super(key: key);
  final VoidCallback onTapSelectCategory;

  @override
  Widget build(BuildContext context) {
    final orderSelect = useState<OrderType>(context.select<FeedBloc, OrderType>((value) =>
        (value.state is FeedData) ? (value.state as FeedData).orderType : OrderType.asc));

    final categoryList =
        context.select<FeedBloc, List<CategoryModel>>((notifier) => notifier.categoryList);

    final stateController = useState(MaterialStatesController());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      color: Colors.white,
      height: 44.h,
      child: Row(
        children: [
          // 오름차순 버튼
          FeedOrderButton(
            orderType: OrderType.asc,
            selected: orderSelect.value == OrderType.asc,
            onOrderTypeChanged: (orderType) {
              //TODO: scrollController로 스크롤 최상단으로 이동
              onTapSelectCategory();

              orderSelect.value = orderType;
              context.read<FeedBloc>().add(FeedOrderChanged(orderType));
            },
          ),

          SizedBox(width: 5.w),

          // 내림차순 버튼
          FeedOrderButton(
            orderType: OrderType.desc,
            selected: orderSelect.value == OrderType.desc,
            onOrderTypeChanged: (orderType) {
              //TODO: scrollController로 스크롤 최상단으로 이동
              onTapSelectCategory();

              orderSelect.value = orderType;
              context.read<FeedBloc>().add(FeedOrderChanged(orderType));
            },
          ),

          //
          const Spacer(),

          //
          Builder(builder: (innerContext) {
            return SizedBox(
              width: 48.w,
              height: 24.h,
              child: ElevatedButton(
                statesController: stateController.value,
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                  elevation: MaterialStateProperty.resolveWith<double>((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return 0;
                    }
                    return 0;
                  }),
                  backgroundColor: const MaterialStatePropertyAll(Colors.white),
                  splashFactory: NoSplash.splashFactory,
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.r),
                      side: BorderSide(color: Theme.of(context).dividerColor, width: 1.w),
                    ),
                  ),
                ),
                onPressed: () async {
                  final selectedCategory = await showDialog(
                    context: innerContext,
                    builder: (context) => FeedCategoryChangeDialog(
                      parentContext: innerContext,
                    ),
                  );

                  if (selectedCategory != null) {
                    Logger().d(selectedCategory);

                    context.read<FeedBloc>().add(FeedCategoryChanged(selectedCategory));
                  }
                },
                child: Text('필터', style: Theme.of(context).textTheme.titleSmall),
              ),
            );
          }),
        ],
      ),
    );
  }
}
