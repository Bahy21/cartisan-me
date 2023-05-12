import 'dart:developer';

import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/review_model.dart';
import 'package:cartisan/app/services/api_calls.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PostsRepo {
  final ApiCalls _apiCalls = ApiCalls();
  final Dio dio = Dio();
  String get _currentUid => FirebaseAuth.instance.currentUser!.uid;

  Future<PostModel?> fetchPost(String postId) async {
    try {
      final result = await dio.get<Map>(_apiCalls.getApiCalls.getPost(postId));
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      final postMap = result.data!['data'] as Map<String, dynamic>;
      if (postMap.isEmpty) {
        return null;
      }
      final newPost = PostModel.fromMap(postMap);
      return newPost;
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> newPost(PostModel post) async {
    try {
      final result = await dio.post<Map>(
        _apiCalls.postApiCalls.createPost(_currentUid),
        data: post.toJson(),
      );
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      final result =
          await dio.delete<Map>(_apiCalls.deleteApiCalls.deletePost(postId));
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<bool> addReview(
    ReviewModel review,
    String postId,
  ) async {
    try {
      final result = await dio.post<Map>(
        _apiCalls.postApiCalls.createReview(postId),
        data: review.toJson(),
      );
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<bool> likePost({
    required String userId,
    required String postId,
  }) async {
    try {
      final result = await dio.put<Map>(
        _apiCalls.putApiCalls.likePost(userId: userId, postId: postId),
      );
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<bool> unlikePost(
      {required String userId, required String postId}) async {
    try {
      final result = await dio.delete<Map>(
        _apiCalls.deleteApiCalls.unlikePost(userId: userId, postId: postId),
      );
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
}
