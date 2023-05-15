import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/search_model.dart';
import 'package:cartisan/app/services/api_calls.dart';

const String GET_SEARCH_POSTS = '$BASE_URL/search/fetchPosts';

class SearchAPI {
  final apiService = APIService();

  Future<List<SearchModel>> getSearches(String userId, {int count = 20}) async {
    try {
      final result =
          await apiService.get<String>('$GET_SEARCH_POSTS/$userId/$count');
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = jsonDecode(result.data.toString()) as List;
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
