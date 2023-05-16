import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/profile/components/user_explore_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
          child: const SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Placeholder(),
            ),
          ),
        );
      },
    );
  }
}

class GridAllUserPosts extends StatefulWidget {
  const GridAllUserPosts({super.key});

  @override
  State<GridAllUserPosts> createState() => _GridAllUserPostsState();
}

class _GridAllUserPostsState extends State<GridAllUserPosts> {
  static const _pageSize = 9;
  final userApi = UserAPI();
  final PagingController<int, PostModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final uid = Get.find<AuthService>().currentUser!.uid;
      final allItems = _pagingController.value.itemList;
      final newItems = await userApi.getAllUserPosts(
        uid,
        lastPostId: allItems?.isNotEmpty ?? false
            ? allItems![pageKey - 1].postId
            : null,
      );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } on Exception catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, PostModel>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<PostModel>(
        itemBuilder: (context, item, index) => UserExploreCard(
          post: item,
        ),
      ),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    );
  }
}
