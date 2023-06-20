import 'package:commento_assignment/screens/feed/widgets/feed_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/category_model.dart';
import '../../../provider/feed_provider.dart';
import 'feed_order_button.dart';

class FeedFilterWidget extends HookWidget {
  const FeedFilterWidget({Key? key, required this.onTapSelectCategory}) : super(key: key);

  final VoidCallback onTapSelectCategory;

  @override
  Widget build(BuildContext context) {
    final orderSelect = useState<OrderType>(context.select<FeedNotifier, OrderType>((value) =>
        (value.state is FeedData) ? (value.state as FeedData).orderType : OrderType.asc));

    final categoryList =
        context.select<FeedNotifier, List<CategoryModel>>((notifier) => notifier.category);

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
              if (orderSelect.value == orderType) {
                //TODO: scrollController로 스크롤 최상단으로 이동
                onTapSelectCategory();
                return;
              }
              orderSelect.value = orderType;
              context.read<FeedNotifier>().changeOrder(orderType);
            },
          ),

          SizedBox(width: 5.w),

          // 내림차순 버튼
          FeedOrderButton(
            orderType: OrderType.desc,
            selected: orderSelect.value == OrderType.desc,
            onOrderTypeChanged: (orderType) {
              if (orderSelect.value == orderType) {
                //TODO: scrollController로 스크롤 최상단으로 이동
                onTapSelectCategory();
                return;
              }
              orderSelect.value = orderType;
              context.read<FeedNotifier>().changeOrder(orderType);
            },
          ),

          //
          const Spacer(),

          //
          SizedBox(
            width: 48.w,
            height: 24.h,
            child: ElevatedButton(
              statesController: stateController.value,
              style: ButtonStyle(
                padding:
                    MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h)),
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
                final currentFilter =
                    (Provider.of<FeedNotifier>(context, listen: false).state as FeedData).category;

                final selectedCategory = await showDialog(
                  context: context,
                  builder: (context) => FeedCategoryChangeDialog(
                    categoryList: categoryList,
                    currentFilter: currentFilter,
                  ),
                );

                if (selectedCategory != null) {
                  context.read<FeedNotifier>().changeCategory(selectedCategory);
                }

                // final selectedCategory = await showDialog<List<CategoryModel>>(
                //   context: context,
                //   barrierDismissible: false,
                //   barrierColor: Colors.black.withOpacity(0.7),
                //   builder: (context) => SizedBox(
                //     width: 337.w,
                //     height: 268.h,
                //     child: FeedCategoryChangeDialog(
                //       categoryList: (feedBloc.state as FeedData).category,
                //       categoryInState: (feedBloc.state as FeedData).category,
                //     ),
                //   ),
                // );

                // if (selectedCategory != null) {}
              },
              child: Text(
                '필터',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
