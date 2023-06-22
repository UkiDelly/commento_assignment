import 'package:commento_assignment/bloc/detail/detail_bloc.dart';
import 'package:commento_assignment/bloc/detail/detail_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum FeedDetailOrder {
  latest("최신순"),
  oldest("등록순");

  final String text;
  const FeedDetailOrder(this.text);
}

class FeedDetailChangeOrderWidget extends HookWidget {
  const FeedDetailChangeOrderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = useState<FeedDetailOrder>(FeedDetailOrder.latest);

    return DropdownButton<FeedDetailOrder>(
      underline: const SizedBox(),
      value: order.value,
      borderRadius: BorderRadius.circular(10.r),
      items: const [
        DropdownMenuItem(value: FeedDetailOrder.latest, child: Text('최신순')),
        DropdownMenuItem(value: FeedDetailOrder.oldest, child: Text('등록순')),
      ],
      onChanged: (value) {
        order.value = value!;

        context.read<FeedDetailBloc>().add(FeedDetailChangeOrderEvent(order.value));
      },
    );
  }
}
