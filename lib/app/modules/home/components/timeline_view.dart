import 'dart:developer';

import 'package:cartisan/app/api_classes/cart_api.dart';
import 'package:cartisan/app/api_classes/timeline_api.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({super.key});

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  int retries = 0;
  final cartAPI = CartAPI();
  final PagingController<int, PostResponse> _pagingController =
      PagingController(firstPageKey: 0);
  final as = Get.find<AuthService>();
  final tc = Get.find<TimelineController>();
  @override
  void initState() {
    _fetchPage(0);
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  TimelineAPI timelineAPI = TimelineAPI();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final uid = Get.find<AuthService>().currentUser!.uid;
      final allItems = _pagingController.value.itemList;
      final newItems = await timelineAPI.fetchTimelinePosts(
        uid: uid,
        lastPostId: allItems == null ? null : allItems[pageKey - 1].post.postId,
      );
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      tc.setLocalFalse();
      if (pageKey == 0) {
        await tc.storeLocal(newItems);
      }
    } on Exception catch (error) {
      retries++;
      if (retries < 3) {
        await _fetchPage(pageKey);
      }
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    tc.setLocalTrue();
    super.dispose();
  }

  Future<void> addToCart(PostModel post) async {
    final result = await cartAPI.addToCart(
      postId: post.postId,
      userId: Get.find<AuthService>().currentUser!.uid,
      selectedVariant: post.selectedVariant,
      quantity: post.quantity,
    );
    if (result) {
      showToast('Added to cart');
    } else {
      await showErrorDialog('Error adding to cart');
    }
  }

  @override
  Widget build(BuildContext context) => GetX<TimelineController>(
        init: TimelineController(),
        builder: (controller) {
          if (as.userToken.isEmpty) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final posts = controller.loadLocal();
          if (posts.isEmpty) {
            controller.setLocalFalse();
          }
          if (controller.loadingLocal) {
            log('loading local');
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  addToCartCallback: () {
                    addToCart(posts[index].post);
                  },
                  postResponse: posts[index],
                );
              },
            );
          }
          log('now displaying live');
          return RefreshIndicator.adaptive(
            onRefresh: () => Future.sync(
              _pagingController.refresh,
            ),
            child: PagedListView<int, PostResponse>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<PostResponse>(
                itemBuilder: (context, item, index) => PostCard(
                  addToCartCallback: () {
                    addToCart(item.post);
                  },
                  postResponse: item,
                ),
              ),
            ),
          );
        },
      );
}
