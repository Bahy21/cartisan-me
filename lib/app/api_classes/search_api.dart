import 'dart:developer';
import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/search_model.dart';

String GET_SEARCH_POSTS = '$BASE_URL/search/fetchPosts';

class SearchAPI {
  final apiService = APIService();

  Future<List<SearchModel>> getSearches(String userId,
      {String? lastPostId, int count = 20}) async {
    try {
      final link = '$GET_SEARCH_POSTS/$userId/$count';
      final result = await apiService.get<Map>(
        link,
        queryParameters: <String, dynamic>{
          'lastPostId': lastPostId,
        },
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = result.data!['result'] as List;
      final searches = <SearchModel>[];
      for (final search in data) {
        searches.add(SearchModel.fromMap(search as Map<String, dynamic>));
      }
      return searches;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }
}
