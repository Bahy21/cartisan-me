import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const String IS_FOLLOWING = '$BASE_URL/social/isFollowing';
const String GET_FOLLOWING = '$BASE_URL/social/getFollowing';
const String GET_FOLLOWERS = '$BASE_URL/social/getFollowers';
const String IS_BLOCKED = '$BASE_URL/social/isBlocked';
const String GET_BLOCK_LIST = '$BASE_URL/social/getBlockList';
const String IS_LIKED = '$BASE_URL/social/isLiked';
const String GET_LIKES = '$BASE_URL/social/getLikes';
const String UNFOLLOW_USER = '$BASE_URL/social/unfollowUser';
const String FOLLOW_USER = '$BASE_URL/social/followUser';
const String UNBLOCK_USER = '$BASE_URL/social/unblockUser';
const String BLOCK_USER = '$BASE_URL/social/blockUser';
const String LIKE_POST = '$BASE_URL/post/likePost';

class SocialAPI {
  final apiService = APIService();
  Future<bool> likePost({
    required String userId,
    required String postId,
  }) async {
    try {
      final result =
          await apiService.put<Map>('$LIKE_POST/$userId/$postId', null);
      if (result.statusCode != 200) {
        throw Exception('Error liking post');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> blockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    try {
      final result =
          await apiService.put<Map>('$BLOCK_USER/$blockerId/$blockedId', null);
      if (result.statusCode != 200) {
        throw Exception('Error blocking user');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> unblockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    try {
      final result = await apiService.delete<Map>(
        '$UNBLOCK_USER/$blockerId/$blockedId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error unblocking user');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> isFollowing({
    required String userId,
    required String followId,
  }) async {
    try {
      final result = await apiService.get<Map>(
        '$IS_FOLLOWING/$userId/$followId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching follow or not follow');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<UserModel>> getFollowing(String userId,
      {String? lastSentFollowingId}) async {
    try {
      final result = await apiService.getPaginate<Map>(
        '$GET_FOLLOWING/$userId',
        <String, dynamic>{'lastSentFollowingId': lastSentFollowingId},
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching following');
      }
      final data = jsonDecode(result.data.toString()) as List;
      final following = <UserModel>[];
      for (final follow in data) {
        following.add(UserModel.fromMap(follow as Map<String, dynamic>));
      }
      return following;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<UserModel>> getFollowers(
    String userId, {
    String? lastSentFollowerId,
  }) async {
    try {
      final result = await apiService.getPaginate<Map>(
        '$GET_FOLLOWERS/$userId',
        <String, dynamic>{'lastSentFollowerId': lastSentFollowerId},
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching followers');
      }
      final data = jsonDecode(result.data.toString()) as List;
      final followers = <UserModel>[];
      for (final follower in data) {
        followers.add(UserModel.fromMap(follower as Map<String, dynamic>));
      }
      return followers;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> isBlocked({
    required String blockerId,
    required String blockedId,
  }) async {
    try {
      final result = await apiService.get<Map>(
        '$IS_BLOCKED/$blockerId/$blockedId',
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

  Future<List<Map>> getBlockList(String userId) async {
    try {
      final result = await apiService.get<Map>(
        '$GET_BLOCK_LIST/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching block list');
      }
      final data = jsonDecode(result.data.toString()) as List;
      return data.cast<Map>();
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> isLiked({required String userId, required String postId}) async {
    try {
      final result = await apiService.get<Map>(
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
      final result = await apiService.get<Map>('GET_LIKES/$postId');
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
      final result = await apiService.delete<Map>(
        '$UNFOLLOW_USER/$userId/$followId',
      );
      log(result.toString());
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
      if (kDebugMode) {
        print('$FOLLOW_USER/$userId/$followId');
      }
      final result =
          await apiService.put<Map>('$FOLLOW_USER/$userId/$followId', null);
      log(result.toString());
      if (result.statusCode != 200) {
        throw Exception('Error updating user delivery');
      }
      return true;
    } on DioError catch (e) {
      log(e.toString());
      return false;
    }
  }
}
