import 'package:cartisan/app/api_controllers.dart/cart_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/cart_item_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cartAPI = CartAPI();
  bool get isCartEmpty => _isCartEmpty.value;
  List<CartItemModel> get cart => _cart.value;
  // ignore: prefer_final_fields
  Rx<List<CartItemModel>> _cart = Rx<List<CartItemModel>>([]);
  // ignore: prefer_final_fields
  RxBool _isCartEmpty = true.obs;
  String get _currentUid => Get.find<AuthService>().currentUser!.uid;
  @override
  void onInit() {
    getCart();
    super.onInit();
  }

  void checkCartEmpty() {
    if (_cart.value.isEmpty) {
      _isCartEmpty.value = true;
    } else {
      _isCartEmpty.value = false;
    }
  }

  Future<void> getCart() async {
    _cart.value = await cartAPI.getCart(_currentUid);
    checkCartEmpty();
  }

  Future<void> deleteCartItem(String cartItemId) async {
    final success = await cartAPI.deleteCartItem(
      userId: _currentUid,
      cartItemId: cartItemId,
    );
    if (success) {
      for (final cartItem in cart) {
        if (cartItem.cartItemId == cartItemId) {
          cart.remove(cartItem);
          break;
        }
      }
      checkCartEmpty();
    } else {
      await showErrorDialog('Error deleting item from cart');
    }
  }

  Future<void> clearCart() async {
    if (await cartAPI.clearCart(_currentUid)) {
      _cart.value = [];
      checkCartEmpty();
    } else {
      await showErrorDialog('Error clearing cart');
    }
  }
}
