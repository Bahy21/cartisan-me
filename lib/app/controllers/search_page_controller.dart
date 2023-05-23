import 'dart:developer';
import 'package:cartisan/app/models/search_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SearchPageController extends GetxController {
  final box = GetStorage('searchLocalStorage');
  bool get loadingLocal => _loadingLocal.value;
  final RxBool _loadingLocal = true.obs;

  List<SearchModel> loadLocal() {
    final result = box.read<List>('posts');
    if (result != null) {
      final posts = <SearchModel>[];
      for (final post in result) {
        posts.add(SearchModel.fromMap(post as Map<String, dynamic>));
      }
      return posts;
    } else {
      _loadingLocal.value = false;
      return [];
    }
  }

  void setLocalFalse() {
    _loadingLocal.value = false;
    log('local set to false');
  }

  void setLocalTrue() {
    _loadingLocal.value = true;
    log('search local set to true');
  }

  Future<bool> storeLocal(List<SearchModel> posts) async {
    try {
      await box.write('posts', posts.map((e) => e.toMap()).toList());
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
