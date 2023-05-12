import 'dart:convert';
import 'dart:developer';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/services/api_calls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelineController extends GetxController {
  final as = Get.find<AuthService>();
  final dio = Dio();
  final apiCalls = ApiCalls();
  List<PostModel> get timelinePosts => _timelinePosts.value;
  bool get hasMore => _hasMore.value;
  bool get isLoading => _isLoading.value;
  int get totalPostsLoaded => _totalPostsLoaded.value;
  bool get isPostLoading => _isPostLoading.value;
  bool get errorLoading => _errorLoading.value;
  Rx<List<PostModel>> _timelinePosts = Rx<List<PostModel>>(<PostModel>[]);
  RxBool _hasMore = true.obs;
  RxBool _isLoading = true.obs;
  RxInt _totalPostsLoaded = 0.obs;
  RxBool _isPostLoading = false.obs;
  RxBool _errorLoading = false.obs;

  String get _currentUid => as.currentUser!.uid;

  @override
  Future<void> onReady() async {
    await fetchPosts();

    super.onReady();
  }

  void refreshActivity() {
    _totalPostsLoaded.value = 0;
    _timelinePosts.value = [];
    fetchPosts(isRefresh: true);
  }

  Future<void> fetchPosts({bool isRefresh = false}) async {
    try {
      _isPostLoading.value = true;
      if (isRefresh) {
        _isLoading.value = true;
      }
      List<PostModel> newPosts = <PostModel>[];
      log('fetching posts on init');
      String? lastId;
      if (_timelinePosts.value.isNotEmpty && !isRefresh) {
        lastId = _timelinePosts.value.last.postId;
      }
      final results = await dio.get<Map>(
        apiCalls.getApiCalls.getTimeline(_currentUid),
        data: jsonEncode({'lastPostId': lastId}),
      );
      log(results.toString());
      final postsGotten = results.data!['result'] as List;
      if (postsGotten.isEmpty) {
        _isPostLoading.value = false;
        _isLoading.value = false;
        _hasMore.value = false;
        return;
      }
      _totalPostsLoaded.value = isRefresh
          ? postsGotten.length
          : _totalPostsLoaded.value + postsGotten.length;
      for (final post in postsGotten) {
        newPosts.add(PostModel.fromMap(post as Map<String, dynamic>));
      }
      _timelinePosts.value = [...timelinePosts, ...newPosts];
      _isPostLoading.value = false;
      _isLoading.value = false;
    } on Exception catch (e) {
      log(e.toString());
      _errorLoading.value = true;
    }
  }
}
