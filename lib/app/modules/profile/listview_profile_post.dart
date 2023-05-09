import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListViewProfilePost extends StatelessWidget {
  const ListViewProfilePost({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // TODO: ADD ACTUAL LENGTH
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      itemBuilder: (context, index) {
        // return PostCard(
        //   post: posts[index],
        //   index: index,
        // );
        return Placeholder();
      },
    );
  }
}
