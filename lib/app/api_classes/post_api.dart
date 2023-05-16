import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/comment_model.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/review_model.dart';

const String GET_POST = '$BASE_URL/post/getPost';
const String GET_COMMENTS = '$BASE_URL/post/comments/getComments';
const String CREATE_POST = '$BASE_URL/newPost';
const String CREATE_REVIEW = '$BASE_URL/review/postReview';
const String CREATE_COMMENT = '$BASE_URL/post/comments/newComment';
const String DELETE_COMMENT = '$BASE_URL/post/comments/deleteComment';
const String UNLIKE_POST = '$BASE_URL/post/unlikePost';
const String DELETE_POST = '$BASE_URL/post/deletePost';

class PostAPI {
  final apiService = APIService();

  Future<bool> deletePost(String postId) async {
    try {
      final result = await apiService.delete<String>('$UNLIKE_POST/$postId');
      if (result.statusCode != 200) {
        throw Exception('Error unliking post');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> unlikePost(
      {required String userId, required String postId}) async {
    try {
      final result =
          await apiService.delete<String>('$UNLIKE_POST/$userId/$postId');
      if (result.statusCode != 200) {
        throw Exception('Error unliking post');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteComment(
      {required String postId, required String commentId}) async {
    try {
      final result = await apiService.delete<String>(
        '$DELETE_COMMENT/$postId/$commentId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error deleting comment');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> createComment({
    required String postId,
    required CommentModel newComment,
  }) async {
    try {
      final result = await apiService.post<String>(
        '$CREATE_COMMENT/$postId',
        newComment.toMap(),
      );
      if (result.statusCode != 200) {
        throw Exception('Error creating comment');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> createReview({
    required String postId,
    required ReviewModel newReview,
  }) async {
    try {
      final result = await apiService.post<String>(
        '$CREATE_REVIEW/$postId',
        newReview.toMap(),
      );
      if (result.statusCode != 200) {
        throw Exception('Error creating review');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> createPost({
    required String userId,
    required PostModel newPost,
  }) async {
    try {
      final result = await apiService.post<String>(
        '$CREATE_POST/$userId',
        newPost.toMap(),
      );
      if (result.statusCode != 200) {
        throw Exception('Error creating post');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<PostModel?> getPost(String postId) async {
    try {
      final result = await apiService.get<String>('$GET_POST/$postId');
      if (result.statusCode != 200) {
        throw Exception('Error fetching post');
      }
      final data = jsonDecode(result.data.toString()) as Map<String, dynamic>;
      return PostModel.fromMap(data);
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<CommentModel>> getComments(
    String postId, {
    String? lastCommentId,
  }) async {
    try {
      final result = await apiService.getPaginate<String>(
        '$GET_COMMENTS/$postId',
        {'lastCommentId': lastCommentId},
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching comments');
      }
      final data = jsonDecode(result.data.toString()) as List;
      final comments = <CommentModel>[];
      for (final comment in data) {
        comments.add(CommentModel.fromMap(comment as Map<String, dynamic>));
      }
      return comments;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }
}
