import 'package:cartisan/app/models/delivery_options.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/search/components/explore_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GridViewProfilePost extends StatelessWidget {
  const GridViewProfilePost({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 5, // TODO: ADD ACTUAL explore.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 3.h,
        crossAxisSpacing: 3.w,
      ),
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              // child: ExploreCard(
              //   onTap: () {},
              //   post: ),
              child: Placeholder(),
            ),
          ),
        );
      },
    );
  }
}
