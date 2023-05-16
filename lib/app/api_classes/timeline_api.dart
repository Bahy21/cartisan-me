import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';

const String FETCH_TIMELINE = '$BASE_URL/timeline/fetchPosts';

class TimelineAPI {
  APIService apiService = APIService();

  Future<List<PostResponse>> fetchTimelinePosts({
    required String uid,
    String? lastPostId,
    int count = 10,
  }) async {
    try {
      final result = await apiService.get<Map>('$FETCH_TIMELINE/$uid/$count',
          queryParameters: <String, dynamic>{
            'lastPostId': lastPostId,
          });
      final data = result.data!['result'] as List;
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
