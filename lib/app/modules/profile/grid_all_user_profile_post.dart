
import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/profile/components/empty_post_message.dart';
import 'package:cartisan/app/modules/profile/components/user_explore_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GridAllUserPosts extends StatefulWidget {
  final String? userId;
  const GridAllUserPosts({this.userId, super.key});

  @override
  State<GridAllUserPosts> createState() => _GridAllUserPostsState();
}

class _GridAllUserPostsState extends State<GridAllUserPosts> {
  bool errorFetching = false;
  static const _pageSize = 9;
  final userApi = UserAPI();
  final PagingController<int, PostModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final uid = widget.userId ?? Get.find<AuthService>().currentUser!.uid;
      final allItems = _pagingController.value.itemList;
      final newItems = await userApi.getAllUserPosts(
        uid,
        lastPostId: allItems?.isNotEmpty ?? false
            ? allItems![pageKey - 1].postId
            : null,
      );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        if (allItems == null || allItems.isEmpty) {
          errorFetchingFunction();
        }
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } on Exception catch (error) {
      final allItems = _pagingController.value.itemList;
      if (allItems == null || allItems.isEmpty) {
        errorFetchingFunction();
      }
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void errorFetchingFunction() {
    setState(() {
      errorFetching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return errorFetching &&
            ((_pagingController.value.itemList == null ||
                _pagingController.value.itemList!.isEmpty))
        ? const EmptyPostMessage()
        : PagedGridView<int, PostModel>(
            physics: _pagingController.value.itemList?.isEmpty ?? true
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<PostModel>(
              itemBuilder: (context, item, index) => UserExploreCard(
                post: item,
              ),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
          );
  }
}
