import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  final OrderModel order;
  final postApi = PostAPI();
  OrderDetailController(this.order);

  OrderModel get orderModel => _order.value!;
  Map<String, PostResponse> get posts => _posts.value;
  bool get loading => _loading.value;

  Rx<Map<String, PostResponse>> _posts = Rx<Map<String, PostResponse>>({});
  Rx<OrderModel?> _order = Rx<OrderModel?>(null);
  RxBool _loading = true.obs;

  @override
  void onInit() {
    _order.value = order;
    fetchOrderPosts();
    super.onInit();
  }

  Future<void> fetchOrderPosts() async {
    for (var orderItem in orderModel.orderItems) {
      final post = await postApi.getPost(orderItem.productId);
      if (post != null) _posts.value.addAll({orderItem.orderItemID: post});
    }
    loadingComplete();
  }

  void loadingComplete() {
    _loading.value = false;
  }
}
