import 'dart:developer';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cartisan/app/services/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo {
  final userDb = UserDatabase();
  final Database _database = Database();
  final ApiCalls _apiCalls = ApiCalls();
  final Dio dio = Dio();
  String get _currentUid => FirebaseAuth.instance.currentUser!.uid;

  Stream<UserModel?> currentUserStream() {
    return userDb.usersCollection
        .doc(_currentUid)
        .snapshots()
        .map((event) => event.data());
  }

  Future<UserModel?> fetchUser(String userId) async {
    try {
      final user = await dio.get(_apiCalls.getApiCalls.getUser(userId));
      final userMap = user['data'] as Map<String, dynamic>;
      final newUser = UserModel.fromMap(userMap);
      return newUser;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<PostModel>> fetchUserPosts(String userId) async{
    try{
      final result = await dio.get(_apiCalls.getApiCalls.getUserPosts(userId));
      if (result.isEmpty){
        return [];
      }
      List<PostModel> posts = [];
      for(final post in result['data']){
        posts.add(PostModel.fromMap(post as Map<String, dynamic>));
      }
      return posts;
    } on Exception catch (e){
      print(e.toString());
      return [];
    }
  }

  Future<bool> addUserAddress(AddressModel address) async{
    try{
      final result = dio.put(_apiCalls.putApiCalls.addAddress(_currentUid), data: address.toJson());
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
  
  Future<bool> updateDeliveryInfo({required bool activeShipping, required bool pickup, required bool isDeliveryAvailable}) async{
    try{
      final result = dio.put(_apiCalls.putApiCalls.updateDeliveryInfo(_currentUid), data: {'activeShipping': activeShipping, 'pickup': pickup, 'isDeliveryAvailable': isDeliveryAvailable});
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<void> followUser({required String userId, required String followId,}) async{
    try{
      final result = dio.put(_apiCalls.putApiCalls.followUser(userId:userId, followId:followId));
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
    }
  }
  Future<void> unfollowUser({required String userId, required String followId,}) async{
    try{
      final result = dio.delete(_apiCalls.deleteApiCalls.unfollowUser(userId:userId, followId:followId));
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
    }
  }
  Future<bool> isFollowing({required String userId, required String followId,}) async{
    try{
      final result = dio.get(_apiCalls.getApiCalls.isFollowing(userId:userId, followId:followId));
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
}
