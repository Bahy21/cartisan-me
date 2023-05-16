import 'dart:developer';
import 'package:cartisan/app/api_classes/timeline_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelineController extends GetxController {
  final timelineApi = TimelineAPI();

  List<PostResponse> get timelinePosts => _timelinePosts.value;
  bool get hasMore => _hasMore.value;
  bool get firstLoading => _firstLoading.value;
  bool get arePostsostLoading => _arePostsLoading.value;
  bool get errorLoading => _errorLoading.value;
  ScrollController get contrller => _scrollController.value;
  Rx<List<PostResponse>> _timelinePosts =
      Rx<List<PostResponse>>(<PostResponse>[]);
  RxBool _hasMore = true.obs;
  RxBool _firstLoading = true.obs;
  RxBool _arePostsLoading = false.obs;
  RxBool _errorLoading = false.obs;
  Rx<ScrollController> _scrollController =
      Rx<ScrollController>(ScrollController());

  String get _currentUid => Get.find<AuthService>().currentUser!.uid;

  @override
  Future<void> onReady() async {
    await fetchPosts();
    super.onReady();
  }

  void refreshActivity() {
    _timelinePosts.value = [];
    fetchPosts(isRefresh: true);
  }

  Future<void> fetchPosts({bool isRefresh = false}) async {
    try {
      _arePostsLoading.value = true;
      if (isRefresh) {
        _firstLoading.value = true;
      }

      String? lastId;
      if (_timelinePosts.value.isNotEmpty && !isRefresh) {
        lastId = _timelinePosts.value.last.post.postId;
      }
      final postsGotten = await timelineApi.fetchTimelinePosts(
        uid: _currentUid,
        lastPostId: lastId,
      );
      if (postsGotten.isEmpty && _timelinePosts.value.isEmpty) {
        errorInPostsFinding();
        return;
      }
      if (postsGotten.isEmpty) {
        noMorePostsFound();
        return;
      }

      _timelinePosts.value = [...timelinePosts, ...postsGotten];
      _arePostsLoading.value = false;
      _firstLoading.value = false;
    } on Exception catch (e) {
      log(e.toString());
      errorInPostsFinding();
    }
  }

  void noMorePostsFound() {
    _arePostsLoading.value = false;
    _firstLoading.value = false;
    _hasMore.value = false;
  }

  void errorInPostsFinding() {
    _errorLoading.value = true;
  }
}
