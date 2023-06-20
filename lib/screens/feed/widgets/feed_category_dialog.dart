import 'package:commento_assignment/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedCategoryChangeDialog extends HookWidget {
  const FeedCategoryChangeDialog({
    Key? key,
    required this.categoryList,
    required this.currentFilter,
  }) : super(key: key);

  final List<CategoryModel> categoryList;
  final List<CategoryModel> currentFilter;

  @override
  Widget build(BuildContext context) {
    final categorySelected = useState<List<CategoryModel>>(List.from(categoryList.map((e) {
      if (currentFilter.contains(e)) {
        return e;
      }
    })));

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      content: SizedBox(
        width: 337.w,
        // height: 268.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 닫기 버튼
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 25.w,
                height: 25.h,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  splashColor: Colors.transparent,
                  onTap: () => Navigator.of(context).pop(),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
              ),
            ),

            // 필터
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "필터",
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: const Color(0xff212529),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //
                  SizedBox(height: 11.h),

                  // 카테고리 체크박스 리스트
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 11.h),
                      child: _FilterCheckBox(
                          category: categoryList[index],
                          onSelected: (category) {
                            if (currentFilter.contains(category)) {
                              currentFilter.remove(category);
                            } else {
                              currentFilter.add(category);
                            }
                          },
                          selected: currentFilter.contains(categoryList[index])),
                    ),
                  ),

                  //
                  SizedBox(height: 30.h),

                  //
                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(categorySelected.value);
                      },
                      child: Text(
                        "저장하기",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FilterCheckBox extends HookWidget {
  const _FilterCheckBox({
    required this.category,
    required this.onSelected,
    required this.selected,
  });

  final CategoryModel category;
  final Function(CategoryModel category) onSelected;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final select = useState<bool>(selected);
    return Row(
      children: [
        // 체크 박스
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: Checkbox.adaptive(
            value: select.value,
            onChanged: (value) {
              select.value = value!;

              onSelected(category);
            },
          ),
        ),

        //
        SizedBox(width: 5.w),

        //
        Text(
          category.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
