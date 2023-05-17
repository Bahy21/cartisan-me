import 'dart:developer';

import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:cartisan/app/modules/profile/components/empty_post_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:cartisan/app/controllers/store_page_controller.dart';

class ListAllUserPosts extends StatefulWidget {
  final String? userId;
  const ListAllUserPosts({
    this.userId,
    super.key,
  });

  @override
  State<ListAllUserPosts> createState() => _ListAllUserPosts();
}

class _ListAllUserPosts extends State<ListAllUserPosts> {
  bool errorFetching = false;
  static const _pageSize = 9;
  final userApi = UserAPI();
  final PagingController<int, PostModel> _pagingController =
      PagingController(firstPageKey: 0);

  UserModel? currentlyViewedUser;
  @override
  void initState() {
    currentlyViewedUser = widget.userId == null
        ? Get.find<UserController>().currentUser
        : Get.find<StorePageController>().storeOwner;
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  void errorFetchingFunction() {
    setState(() {
      errorFetching = true;
    });
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
      errorFetchingFunction();
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
    return errorFetching &&
            ((_pagingController.value.itemList == null ||
                _pagingController.value.itemList!.isEmpty))
        ? const EmptyPostMessage()
        : PagedListView<int, PostModel>(
            shrinkWrap: true,
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<PostModel>(
              itemBuilder: (context, item, index) => PostCard(
                postResponse:
                    PostResponse(owner: currentlyViewedUser!, post: item),
              ),
            ),
          );
  }
}
