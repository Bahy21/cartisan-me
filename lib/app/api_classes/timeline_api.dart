import 'dart:developer';
import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:get/get.dart';

String FETCH_TIMELINE = '$BASE_URL/timeline/fetchPosts';

class TimelineAPI {
  APIService apiService = APIService();

  Future<List<PostResponse>> fetchTimelinePosts({
    required String uid,
    String? lastPostId,
    int count = 10,
  }) async {
    try {
      final link = '$FETCH_TIMELINE/$uid/$count';
      final result =
          await apiService.get<Map>(link, queryParameters: <String, dynamic>{
        'lastPostId': lastPostId,
      });
      final data = result.data!['result'] as List;
      final likes = result.data!['likes'] as Map<String, dynamic>;
      Get.find<TimelineController>().addLikes(likes);
      final posts = <PostResponse>[];
      for (final post in data) {
        posts.add(PostResponse.fromMap(post as Map<String, dynamic>));
      }
      return posts;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }
}
