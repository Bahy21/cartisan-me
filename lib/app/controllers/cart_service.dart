import 'dart:convert';
import 'dart:developer';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/services/api_calls.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CartService extends GetxService {
  final as = Get.find<AuthService>();
  final ApiCalls apiCalls = ApiCalls();
  final dio = Dio();
  String get _currentUid => as.currentUser!.uid;

  Future<bool> addToCart(PostModel post) async {
    try {
      final result = await dio.put<Map>(
        apiCalls.putApiCalls
            .addToCart(postId: post.postId, userId: _currentUid),
        data: json.encode(
          {'selectedVariant': post.selectedVariant},
        ),
      );
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
