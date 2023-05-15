import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_controllers.dart/api_service.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/api_calls.dart';

String isFollowing({required String userId, required String followId}) =>
    '$BASE_URL/social/isFollowing/$userId/$followId';
String getFollowing(String userId) => '$BASE_URL/social/getFollowing/$userId';
String getFollowers(String userId) => '$BASE_URL/social/getFollowers/$userId';
const String IS_BLOCKED = '$BASE_URL/social/isBlocked';
const String GET_BLOCK_LIST = '$BASE_URL/social/getBlockList';
const String IS_LIKED = '$BASE_URL/social/isLiked';
const String GET_LIKES = '$BASE_URL/social/getLikes';
const String UNFOLLOW_USER = '$BASE_URL/user/unfollowUser';
const String FOLLOW_USER = '$BASE_URL/user/followUser';

class SocialAPI {
  final apiService = APIService();

  Future<List<UserModel

  Future<bool> isBlocked({
    required String blockerId,
    required String blockedId,
  }) async {
    try {
      final result = await apiService.get<String>(
        'IS_BLOCKED/$blockerId/$blockedId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching block or not blocked');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<String>> getBlockList(String userId) async {
    try {
      final result = await apiService.get<String>(
        '$GET_BLOCK_LIST/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching block list');
      }
      final data = jsonDecode(result.data.toString()) as List;
      return data.cast<String>();
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> isLiked({required String userId, required String postId}) async {
    try {
      final result = await apiService.get<String>(
        '$IS_LIKED/$userId/$postId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching likes');
      }
      final data = jsonDecode(result.data.toString()) as Map<String, dynamic>;
      return data['liked'] as bool;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<UserModel>> fetchLikes(String postId) async {
    try {
      final result = await apiService.get<String>('GET_LIKES/$postId');
      if (result.statusCode != 200) {
        throw Exception('Error fetching likes');
      }
      final data = jsonDecode(result.data.toString()) as List;
      final likes = <UserModel>[];
      for (final like in data) {
        likes.add(UserModel.fromMap(like as Map<String, dynamic>));
      }
      return likes;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> unfollowUser({
    required String userId,
    required String followId,
  }) async {
    try {
      final result = await apiService.delete<String>(
        '$UNFOLLOW_USER/$userId/$followId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error unfollowing user');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> followUser({
    required String userId,
    required String followId,
  }) async {
    try {
      final result =
          await apiService.put<String>('$FOLLOW_USER/$userId/$followId', null);
      if (result.statusCode != 200) {
        throw Exception('Error updating user delivery');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
