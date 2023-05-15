import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/services/api_calls.dart';

const String FETCH_TIMELINE = '$BASE_URL/timeline/fetchPosts';

class TimelineAPI {
  APIService apiService = APIService();

  Future<List<PostModel>> fetchTimelinePosts({
    required String uid,
    String? lastPostId,
    int count = 10,
  }) async {
    try {
      final result = await apiService.getPaginate<String>(
        '$FETCH_TIMELINE/$uid/$count',
        {'lastPostId': lastPostId},
      );
      final data = jsonDecode(result.data.toString()) as List;
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
}
