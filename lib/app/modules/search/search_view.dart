import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/search/components/explore_card.dart';
import 'package:cartisan/app/modules/search/components/searchfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchView extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          SizedBox(height: 50.h),
          SearchField(
            controller: _searchController,
            onSubmitted: (value) {},
          ),
          SizedBox(height: 26.h),
          StaggeredGridView.countBuilder(
            crossAxisCount: 3,
            itemCount: 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Hero(
                      tag: 'explore_card_1',
                      // child: ExploreCard(
                      //   onTap: () {},
                      //   post: explore[index],
                      // ),
                      child: Placeholder(),
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (index) => StaggeredTile.count(
              index % 7 == 0 ? 2 : 1,
              index % 7 == 0 ? 2 : 1,
            ),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            padding: const EdgeInsets.all(8.0),
          ),
        ],
      ),
    );
  }
}
