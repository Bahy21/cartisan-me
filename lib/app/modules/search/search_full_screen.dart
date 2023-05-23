
import 'package:cartisan/app/controllers/get_search_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/search/algolia.dart';
import 'package:cartisan/app/modules/search/components/search_result_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchFullScreen extends StatefulWidget {
  const SearchFullScreen({super.key});

  @override
  State<SearchFullScreen> createState() => SearchFullScreenState();
}

class SearchFullScreenState extends State<SearchFullScreen> {
  @override
  Widget build(BuildContext context) {
    return GetX<GetSearchController>(
      init: GetSearchController(),
      builder: (controller) {
        if (controller.isSearching) {
          return Scaffold(
            appBar: SearchControllerTextField(),
            body: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (controller.postSearchResults?.isEmpty ?? true) {
          return Scaffold(
            appBar: SearchControllerTextField(),
            body: Center(
              child: Text(
                'No results found',
                style: AppTypography.kBold20.copyWith(
                  color: AppColors.kWhite,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: SearchControllerTextField(),
          body: ListView.builder(
            itemCount: controller.postSearchResults!.length,
            itemBuilder: (context, index) {
              final post =
                  PostModel.fromMap(controller.postSearchResults![index].data);
              return SearchResultTile(post);
            },
          ),
        );
      },
    );
  }
}

class SearchControllerTextField extends StatelessWidget
    implements PreferredSizeWidget {
  SearchControllerTextField({super.key});
  final controller = Get.find<GetSearchController>();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AlgoliaSearchField(
        searchType: SearchType.posts,
        isSearching: (status) => controller.setIsSearching = status,
        onSearchComplete: (hits) => controller.setPostSearchResults = hits,
        controller: controller.postSearchController,
      ),
      centerTitle: true,
      toolbarHeight: 80.h,
      leadingWidth: 20.w,
      leading: InkWell(
        onTap: () => Get.back<void>(),
        child: Padding(
          padding: EdgeInsets.only(left: 10.0.w),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.kWhite,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
