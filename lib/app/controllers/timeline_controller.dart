import 'dart:convert';
import 'dart:developer';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/timeline_scroll_controller.dart';
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
  bool get firstLoading => _firstLoading.value;
  int get totalPostsLoaded => _totalPostsLoaded.value;
  bool get arePostsostLoading => _arePostsLoading.value;
  bool get errorLoading => _errorLoading.value;
  ScrollController get contrller => _scrollController.value;
  Rx<List<PostModel>> _timelinePosts = Rx<List<PostModel>>(<PostModel>[]);
  RxBool _hasMore = true.obs;
  RxBool _firstLoading = true.obs;
  RxInt _totalPostsLoaded = 0.obs;
  RxBool _arePostsLoading = false.obs;
  RxBool _errorLoading = false.obs;
  Rx<ScrollController> _scrollController =
      Rx<ScrollController>(ScrollController());

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
      _arePostsLoading.value = true;
      if (isRefresh) {
        _firstLoading.value = true;
      }
      List<PostModel> newPosts = <PostModel>[];
      String? lastId;
      if (_timelinePosts.value.isNotEmpty && !isRefresh) {
        lastId = _timelinePosts.value.last.postId;
      }
      final results = await dio.get<Map>(
        apiCalls.getApiCalls.getTimeline(_currentUid),
        data: jsonEncode({'lastPostId': lastId}),
      );
      final postsGotten = results.data!['result'] as List;
      if (postsGotten.isEmpty) {
        _arePostsLoading.value = false;
        _firstLoading.value = false;
        _hasMore.value = false;
        if (_timelinePosts.value.isEmpty) {
          _errorLoading.value = true;
        }
        return;
      }
      _totalPostsLoaded.value = isRefresh
          ? postsGotten.length
          : _totalPostsLoaded.value + postsGotten.length;
      for (final post in postsGotten) {
        newPosts.add(PostModel.fromMap(post as Map<String, dynamic>));
      }
      _timelinePosts.value = [...timelinePosts, ...newPosts];
      if(firstLoading){
        _arePostsLoading.value = false;
      }
      _firstLoading.value = false;
    } on Exception catch (e) {
      log(e.toString());
      _arePostsLoading.value = false;
      _firstLoading.value = false;
      _errorLoading.value = true;
    }
  }
}
