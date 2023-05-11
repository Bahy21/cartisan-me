import 'dart:developer';

import 'package:cartisan/api_root.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelineController extends GetxController {
  final as = Get.find<AuthService>();
  final dio = Dio();
  final apiCalls = ApiCalls();
  Rx<List<PostModel>> _timelinePosts = Rx<List<PostModel>>(<PostModel>[]);
  List<PostModel> get timelinePosts => _timelinePosts.value;
  Rxbool _hasMore = true.obs;
  bool get hasMore => _hasMore.value;
  Rxbool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  RxInt _totalPostsLoaded = 0.obs;
  int get totalPostsLoaded => _totalPostsLoaded.value;
  Rxbool _isPostLoading = false.obs;
  bool get isPostLoading => _isPostLoading.value;

  String get _currentUid => FirebaseAuth.instance.currentUser!.uid;
  
  @override
  Future<void> onReady() async {
    await fetchPosts();

    super.onReady();
  }

  void refreshActivity(){
    _totalPostsLoaded.value = 0;
    _timelinePosts.value = [];
    fetchPosts(isRefresh: true);
  }
  Future<void> fetchPosts({bool isRefresh = false}) async {
    _isPostLoading.value = true;
    if(isRefresh) {
      _isLoading.value = true;
    }
    List<PostModel> newPosts = <PostModel>[];
    log('fetching posts on init');
    var queryResult;
    String? lastId;
    if(timelinePosts.value.length.isNotEmpty && !isRefresh){
      lastId = timelinePosts.value.last.postId;
    }
    final results = dio.get(apiCalls.getApiCalls.getTimeline(_currentUid), data:{'lastPostId': lastId});
    if (results['data'].isEmpty){
      _isActivityLoading.value = false;
      _isLoading.value = false;
      _hasMore.value = false;
      return;
    }
    _totalActivitiesLoaded.value = isRefresh
        ? results.length
        : _totalActivitiesLoaded.value + results.length;
    for(final post in results){
      newPosts.add(PostModel.fromMap(post.data() as Map<String, dynamic>));
    }
    _timelinePosts.value = [...timelinePosts,...newPosts];
    _isPostLoading.value = false;
    _isLoading.value = false;
  }
}
