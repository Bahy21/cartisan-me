import 'package:cartisan/app/api_classes/cart_api.dart';
import 'package:cartisan/app/models/cart_item_model.dart';
import 'package:test/test.dart';

Future<void> unitTestsCartApi() async {
  final cartApi = CartAPI();
  final testUserId = 'BZITXYeZ4MfMPROh5lxCOF84wFN2';
  final testPostId = '27924507-0a28-406e-b828-275e9fc14f83';
  test('get cart', () async {
    final result = await cartApi.getCart(testUserId);
    expect(result, isA<List<CartItemModel>>());
    expect(result.length, 4);
  });
  test('add to then delete from cart', () async {
    final result = await cartApi.addToCart(
      userId: testUserId,
      postId: testPostId,
      quantity: 1,
      selectedVariant: 'Cotton',
    );
    expect(result, isA<bool>());
    expect(result, true);
    final cart = await cartApi.getCart(testUserId);
    expect(cart.length, 5);
    final deleteResult = await cartApi.deleteCartItem(
        cartItemId: cart.last.cartItemId, userId: testPostId);
    expect(deleteResult, isA<bool>());
    expect(deleteResult, true);
    final updatedCart = await cartApi.getCart(testUserId);
    expect(updatedCart.length, 4);
  });
}
