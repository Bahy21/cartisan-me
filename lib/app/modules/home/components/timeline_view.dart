import 'package:cartisan/app/api_classes/timeline_api.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({super.key});

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  static const _pageSize = 10;

  final PagingController<int, PostResponse> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _fetchPage(0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
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
  Widget build(BuildContext context) =>
      // Don't worry about displaying progress or error indicators on screen; the
      // package takes care of that. If you want to customize them, use the
      // [PagedChildBuilderDelegate] properties.
      PagedListView<int, PostResponse>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<PostResponse>(
          itemBuilder: (context, item, index) => PostCard(
            postResponse: item,
          ),
        ),
      );
}
