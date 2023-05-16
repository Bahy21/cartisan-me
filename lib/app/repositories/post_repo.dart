import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/models/post_response.dart';

class PostRepo {
  PostAPI postAPI = PostAPI();
  Future<PostResponse> getPost(
    String? postId,
    PostResponse? postResponse,
  ) async {
    try {
      if (postResponse != null) {
        return postResponse;
      }
      PostResponse? response;
      response = await postAPI.getPost(postId!);

      return response!;
    } on Exception catch (_) {
      rethrow;
    }
  }
}
