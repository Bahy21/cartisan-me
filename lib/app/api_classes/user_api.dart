import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/api_calls.dart';

const String GET_USER = '$BASE_URL/user/getUser';
const String GET_ALL_USER_POSTS = '$BASE_URL/user/getAllPosts';
const String CREATE_USER = '$BASE_URL/user/createUser';
const String UPDATE_DELIVERY_INFO = '$BASE_URL/user/updateDeliveryInfo';
const String UPDATE_USER_DETAILS = '$BASE_URL/user/updateUser';
const String ADD_ADDRESS = '$BASE_URL/user/addAddress';
const String UPDATE_AREA = '$BASE_URL/user/updateArea';

class UserAPI {
  APIService apiService = APIService();

  Future<UserModel?> getUser(String userId) async {
    try {
      final result = await apiService.get<String>(
        '$GET_USER/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = jsonDecode(result.data.toString()) as Map<String, dynamic>;
      return UserModel.fromMap(data['result'] as Map<String, dynamic>);
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<UserModel>> getAllUserPosts(String userId) async {
    try {
      final result = await apiService.get<String>(
        '$GET_ALL_USER_POSTS/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = jsonDecode(result.data.toString()) as List;
      final posts = <UserModel>[];
      for (final post in data) {
        posts.add(UserModel.fromMap(post as Map<String, dynamic>));
      }
      return posts;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> createUser({
    required String userId,
    required UserModel user,
  }) async {
    try {
      final result =
          await apiService.post<String>('$CREATE_USER/$userId', user.toMap());
      if (result.statusCode != 200) {
        throw Exception('Error creating user');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> updateDeliveryInfo({
    required String userId,
    required Map<String, dynamic> newDelivery,
  }) async {
    try {
      final result = await apiService.put<String>(
        '$UPDATE_DELIVERY_INFO/$userId',
        newDelivery,
      );
      if (result.statusCode != 200) {
        throw Exception('Error updating user delivery');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> updateUserDetails({
    required String userId,
    required UserModel newUser,
  }) async {
    try {
      final result = await apiService.put<String>(
        '$UPDATE_USER_DETAILS/$userId',
        newUser.toJson(),
      );
      if (result.statusCode != 200) {
        throw Exception('Error updating user details');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> addAddress({
    required String userId,
    required AddressModel newAddress,
  }) async {
    try {
      final result = await apiService.put<String>(
        '$ADD_ADDRESS/$userId',
        newAddress.toMap(),
      );
      if (result.statusCode != 200) {
        throw Exception('Error adding address');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> updateArea({
    required String userId,
    required Map<String, dynamic> newAreaMap,
  }) async {
    try {
      final result = await apiService.put<String>(
        '$UPDATE_AREA/$userId',
        newAreaMap,
      );
      if (result.statusCode != 200) {
        throw Exception('Error updating area');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
