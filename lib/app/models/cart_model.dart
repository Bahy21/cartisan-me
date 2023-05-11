class CartModel extends GetXController{
  final ApiCalls apiCalls = ApiCalls();
  final dio = Dio();

  Rx<List<CartItemModel>> _cart = Rx<List<CartItemModel>>(<CartItemModel>[]);
  List<CartModel> get cart => _cart.value;


  Future<void> fetchNotifications(){
    try{
      final result = dio.get(apiCalls.getCart(_currentUid));
    } on Exception catch(e){
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
    }
  }
}