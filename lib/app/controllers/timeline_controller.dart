import 'dart:developer';

import 'package:cartisan/api_root.dart';
import 'package:cartisan/app/controllers/auth_controller.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelineController extends GetxController {
  final ac = Get.find<AuthController>();
  final dio = Dio();

  Rx<List<PostModel>> timelinePosts = Rx<List<PostModel>>(<PostModel>[]);

  Future<bool> fetchPosts() async {
    try {
      final apiCall = '$apiRoot/api/timeline/fetchPosts/${ac.user!.uid}';
      final result = await dio.get<Map>(apiCall);
      if (result.statusCode != 200) {
        throw Exception('Error fetching posts');
      }
      final posts = result.data!['result'] as List;
      for (final post in posts) {
        log(post.toString());
        final newPost = PostModel.fromMap(post as Map<String, dynamic>);
        timelinePosts.value.add(newPost);
      }
      return true;
    } on Exception catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black,
      );
      log(e.toString());
      return false;
    }
  }
}
