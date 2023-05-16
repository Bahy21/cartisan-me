import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/profile/components/user_explore_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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

class ListAllUserPosts extends StatefulWidget {
  const ListAllUserPosts({super.key});

  @override
  State<ListAllUserPosts> createState() => _ListAllUserPosts();
}

class _ListAllUserPosts extends State<ListAllUserPosts> {
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
    return PagedListView<int, PostModel>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<PostModel>(
        itemBuilder: (context, item, index) => UserExploreCard(
          post: item,
        ),
      ),
    );
  }
}
