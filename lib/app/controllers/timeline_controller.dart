import 'dart:developer';
import 'package:cartisan/app/api_classes/social_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TimelineController extends GetxController {
  final box = GetStorage();
  final socialApi = SocialAPI();
  bool get loadingLocal => _loadingLocal.value;
  Map<String, dynamic> get likes => _likes.value;
  String get currentUid => Get.find<AuthService>().currentUser!.uid;
  final RxBool _loadingLocal = true.obs;
  Rx<Map<String, dynamic>> _likes =
      Rx<Map<String, dynamic>>(<String, dynamic>{});
  void addLikes(Map<String, dynamic> likes) {
    _likes.value.addAll(likes);
    storeLocalLikes();
  }

  List<PostResponse> loadLocal() {
    final localPosts = box.read<List>('posts');
    if (localPosts != null) {
      final posts = <PostResponse>[];
      for (final post in localPosts) {
        posts.add(PostResponse.fromMap(post as Map<String, dynamic>));
      }
      return posts;
    } else {
      _loadingLocal.value = false;
      return [];
    }
  }

  Map<String, dynamic> loadLikes() {
    final result = box.read<Map>('likes');
    if (result != null) {
      return result as Map<String, dynamic>;
    } else {
      return <String, dynamic>{};
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

  Future<bool> storeLocalLikes() async {
    try {
      await box.write('likes', likes);
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> handleLikeUnlike(String postId) async {
    final liked = likes[postId] == true;
    if (liked) {
      likes.remove(postId);
    } else {
      likes[postId] = true;
    }
    _likes.refresh();
    bool result;
    if (liked) {
      result = await socialApi.unlikePost(
        postId: postId,
        userId: currentUid,
      );
      log('unliked');
    } else {
      result = await socialApi.likePost(
        postId: postId,
        userId: currentUid,
      );
      log('liked');
    }
    if (result) {
      if (liked) {
        likes.remove(postId);
      } else {
        likes[postId] = true;
      }
    } else {
      await showErrorDialog('Error liking post');
    }
    await storeLocalLikes();
    _likes.refresh();
  }
}
