import 'dart:developer';
import 'package:cartisan/app/models/post_response.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TimelineController extends GetxController {
  final box = GetStorage();
  bool get loadingLocal => _loadingLocal.value;
  final RxBool _loadingLocal = true.obs;

  List<PostResponse> loadLocal() {
    final result = box.read<List>('posts');
    if (result != null) {
      final posts = <PostResponse>[];
      for (final post in result) {
        posts.add(PostResponse.fromMap(post as Map<String, dynamic>));
      }
      return posts;
    } else {
      _loadingLocal.value = false;
      return [];
    }
  }

  void setLocalFalse() {
    _loadingLocal.value = false;
  }

  void setLocalTrue() {
    _loadingLocal.value = true;
  }

  Future<bool> storeLocal(List<PostResponse> posts) async {
    try {
      await box.write('posts', posts.map((e) => e.toMap()).toList());
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
