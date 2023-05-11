class CartService extends GetXService{
  final as = Get.find<AuthService>();
  final ApiCalls apiCalls = ApiCalls();
  final dio = Dio();
  String get _currentUid => as.currentUser!.uid;

  Future<bool> addToCart(PostModel post){
    try{
      final result = dio.put(apiCalls.putApiCalls.addToCart(postId: post.postId, userId: _currentUid), data: post.toJson());
      if(result.status != 200){
        throw Exception('Something went wrong');
        return false;
      }
      return true;
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
}