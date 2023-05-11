class PostsRepo{
  final ApiCalls _apiCalls = ApiCalls();
  final Dio dio = Dio();
  String get _currentUid => FirebaseAuth.instance.currentUser!.uid;

  Future<PostModel?> fetchPost(String postId) async {
    try {
      final result = await dio.get(_apiCalls.getApiCalls.getPost(postId));
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
      final postMap = result['data'] as Map<String, dynamic>;
      if(postMap.isEmpty){
        return null;
      }
      final newPost = PostModel.fromMap(postMap);
      return newPost;
    } on Exception catch (e) {
      print(e.toString());
      return null
    }
  }
  Future<bool> newPost(PostModel post) async{
    try{
      final result = dio.post(_apiCalls.postApiCalls.newPost(_currentUid), data: post.toJson());
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
  Future<bool> deletePost(String postId) async{
    try{
      final result = dio.delete(_apiCalls.deleteApiCalls.deletePost(postId));
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<bool> addReview(ReviewModel review) async{
    try{
      final result = dio.post(_apiCalls.postApiCalls.addReview(review.postId), data: review.toJson());
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }

  }

  Future<bool> likePost({required String userId, required String postId}) async{
    try{
      final result = dio.put(_apiCalls.putApiCalls.likePost(userId: userId, postId: postId));
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
  Future<bool> unlikePost({required String userId, required String postId}) async{
    try{
      final result = dio.delete(_apiCalls.deleteApiCalls.unlikePost(userId: userId, postId: postId));
      if(result.status != 200){
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  } 
}