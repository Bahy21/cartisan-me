import 'dart:developer';
import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';

String GET_USER = '$BASE_URL/user/getUser';
String GET_ALL_USER_POSTS = '$BASE_URL/user/getAllPosts';
String CREATE_USER = '$BASE_URL/user/createUser';
String UPDATE_DELIVERY_INFO = '$BASE_URL/user/updateDeliveryInfo';
String UPDATE_USER_DETAILS = '$BASE_URL/user/updateUser';
String ADD_ADDRESS = '$BASE_URL/user/addAddress';
String UPDATE_AREA = '$BASE_URL/user/updateArea';
String GET_USER_POST_COUNT = '$BASE_URL/user/getPostCount';
String GET_ALL_USER_ADDRESSES = '$BASE_URL/user/getAllAddresses';
String UPDATE_ADDRESS = '$BASE_URL/user/updateAddress';
String DELETE_ADDRESS = '$BASE_URL/user/deleteAddress';

class UserAPI {
  APIService apiService = APIService();

  Future<UserModel?> getUser(String userId) async {
    try {
      final link = '$GET_USER/$userId';
      final result = await apiService.get<Map>(
        link,
      );

      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      return UserModel.fromMap(result.data!['data'] as Map<String, dynamic>);
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> deleteAddress({
    required String userId,
    required String addressId,
  }) async {
    try {
      final link = '$DELETE_ADDRESS/$userId/$addressId';
      final result = await apiService.delete<Map>(
        link,
      );
      if (result.statusCode != 200) {
        throw Exception('Error deleting address');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> updateAddress({
    required String userId,
    required String addressId,
    required AddressModel address,
  }) async {
    try {
      final link = '$UPDATE_ADDRESS/$userId/$addressId';
      final result = await apiService.put<Map>(
        link,
        address.toMap(),
      );
      if (result.statusCode != 200) {
        throw Exception('Error updating address');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<AddressModel>> getAllUserAddresses(String uid) async {
    try {
      final link = '$GET_ALL_USER_ADDRESSES/$uid';
      final result = await apiService.get<Map>(
        link,
      );
      log(result.toString());
      final data = result.data!['data'] as List;
      final addresses = <AddressModel>[];
      for (final address in data) {
        addresses.add(AddressModel.fromMap(address as Map<String, dynamic>));
      }
      return addresses;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<int> getUserPostCount(String userId) async {
    try {
      final link = '$GET_USER_POST_COUNT/$userId';
      final result = await apiService.get<Map>(
        link,
      );

      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      return result.data!['data'] as int;
    } on Exception catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<List<PostModel>> getAllUserPosts(
    String userId, {
    String? lastPostId,
  }) async {
    try {
      final result = await apiService.getPaginate<Map>(
        '$GET_ALL_USER_POSTS/$userId',
        <String, dynamic>{'lastPostId': lastPostId},
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = result.data!['data'] as List;
      final posts = <PostModel>[];
      for (final post in data) {
        posts.add(PostModel.fromMap(post as Map<String, dynamic>));
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
          await apiService.post<Map>('$CREATE_USER/$userId', user.toMap());
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
      final result = await apiService.put<Map>(
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
      final url = '$UPDATE_USER_DETAILS/$userId';
      final payload = newUser.toMap();
      final result = await apiService.put<Map>(
        url,
        payload,
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
      final result = await apiService.put<Map>(
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
      final result = await apiService.put<Map>(
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
