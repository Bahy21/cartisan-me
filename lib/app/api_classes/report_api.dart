import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:get/get.dart';

String REPORT_USER = '$BASE_URL/social/reportUser';
String REPORT_POST = '$BASE_URL/post/reportPost';

class ReportAPI {
  final apiService = APIService();

  Future<bool> reportUser({
    required String reportedId,
    required String reportedFor,
  }) async {
    try {
      final userId = Get.find<AuthService>().currentUser!.uid;
      final link = '$REPORT_USER/$userId';
      final result = await apiService.post<Map>(
        link,
        <String, dynamic>{
          'reportedId': reportedId,
          'reportedFor': reportedFor,
        },
      );
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> reportPost({
    required PostModel post,
    required String reportedFor,
  }) async {
    final userId = Get.find<AuthService>().currentUser!.uid;
    try {
      final link = '$REPORT_POST/${post.postId}';
      final result = await apiService.post<Map>(
        link,
        <String, dynamic>{
          'reportedFor': reportedFor,
          'postId': post.postId,
          'reportUserId': post.ownerId,
        },
      );
      if (result.statusCode != 200) {
        throw Exception('Error reporting post');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
