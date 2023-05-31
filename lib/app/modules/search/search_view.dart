import 'dart:developer';

import 'package:cartisan/app/api_classes/search_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/search_page_controller.dart';
import 'package:cartisan/app/models/search_model.dart';
import 'package:cartisan/app/modules/search/components/explore_card.dart';
import 'package:cartisan/app/modules/search/components/post_full_screen.dart';
import 'package:cartisan/app/modules/search/components/searchfield.dart';
import 'package:cartisan/app/modules/search/search_full_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final searchApi = SearchAPI();

  final PagingController<int, SearchModel> _pagingController =
      PagingController(firstPageKey: 0);
  final spc = Get.find<SearchPageController>();
  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final uid = Get.find<AuthService>().currentUser!.uid;
      final allItems = _pagingController.value.itemList;
      final newItems = await searchApi.getSearches(
        uid,
        lastPostId: allItems?.isNotEmpty ?? false
            ? allItems![pageKey - 1].postId
            : null,
      );
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      spc.setLocalFalse();
      if (pageKey == 0) {
        await spc.storeLocal(newItems);
      }
    } on Exception catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    spc.setLocalTrue();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SearchPageController>(
      init: SearchPageController(),
      builder: (controller) {
        final localPosts = controller.loadLocal();
        if (localPosts.isEmpty) {
          controller.setLocalFalse();
        }
        if (controller.loadingLocal) {
          log('loading local');
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80.h,
              automaticallyImplyLeading: false,
              title: InkWell(
                onTap: () {
                  Get.to<Widget>(SearchFullScreen.new);
                },
                child: const SearchField(),
              ),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: () => _fetchPage(0),
              child: GridView.builder(
                itemCount: localPosts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return ExploreCard(
                    onTap: () => Get.to<Widget>(
                      () => PostFullScreen(
                        postId: localPosts[index].postId,
                      ),
                    ),
                    post: localPosts[index],
                  );
                },
              ),
            ),
          );
        }
        log('switching search to live');
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80.h,
            automaticallyImplyLeading: false,
            title: InkWell(
              onTap: () {
                Get.to<Widget>(SearchFullScreen.new);
              },
              child: const SearchField(),
            ),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () => Future.sync(
              _pagingController.refresh,
            ),
            child: PagedGridView<int, SearchModel>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<SearchModel>(
                itemBuilder: (context, item, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Hero(
                          tag: item.postId,
                          child: ExploreCard(
                            onTap: () => Get.to<Widget>(
                              () => PostFullScreen(
                                postId: item.postId,
                              ),
                            ),
                            post: item,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
            ),
          ),
        );
      },
    );
  }
}
