import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/models/cart_item_model.dart';
import 'package:cartisan/app/models/delivery_options.dart';
import 'package:cartisan/app/models/notification_model.dart';
import 'package:cartisan/app/models/notification_type.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/models/review_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_helpers/test_helpers.mocks.dart';

void main() async {
  final samplePost = PostModel(
    postId: 'abc',
    ownerId: 'xyz',
    description: 'mock description',
    productName: 'mock name',
    brand: 'mock Brand',
    variants: ['mock1', 'mock2', 'mock3'],
    price: 0,
    location: 'mock location',
    rating: 0,
    images: ['mock image1', 'mock image2'],
    selectedVariant: 'mock1',
    quantity: 0,
    isProductInStock: true,
    archived: false,
    sellCount: 0,
    commentCount: 0,
    reviewCount: 0,
    likesCount: 0,
    deliveryOptions: DeliveryOptions.pickup,
  );
  final sampleUser = UserModel(
    id: '',
    username: 'mock username',
    url: 'mock image1',
    email: 'mock email',
  );
  final samplePostResponse = PostResponse(
    post: samplePost,
    owner: sampleUser,
  );
  final sampleReview = ReviewModel(
    reviewID: '',
    reviewText: 'mock review text',
    rating: 0,
    reviewerName: 'mock reviewer name',
    reviewerId: '',
    timestamp: 0,
  );
  final sampleCartItem = CartItemModel(
    cartItemId: '',
    postId: '',
    sellerId: '',
    username: 'mock username',
    description: 'mock description',
    productname: 'mock product name',
    brand: 'mock brand',
    deliveryOptions: DeliveryOptions.pickup,
    price: 0,
    discount: 0,
    priceInCents: 0,
    discountInCents: 0,
    images: ['mock image1', 'mock image2'],
    selectedVariant: 'mock variant1',
    variants: ['mock variant1', 'mock variant2'],
    quantity: 1,
  );
  final sampleNotification = NotificationModel(
    notificationId: '',
    ownerId: '',
    userId: '',
    type: NotificationType.follow,
    timestamp: 0,
    username: 'mock username',
    userProfileImg: 'mock userProfileImg',
  );
  final sampleAddress = AddressModel(
    userID: '',
    addressID: '',
    addressLine1: 'mock addressLine1',
    addressLine2: 'mock addressLine2',
    addressLine3: 'mock addressLine3',
    postalCode: '1234',
    contactNumber: 'mock contactNumber',
    city: 'mock city',
    state: 'mock state',
    fullname: 'mock fullname',
  );
  final sampleOrderItem = OrderItemModel(
    orderItemID: '',
    productId: '',
    selectedVariant: '',
    appFeeInCents: 0,
    quantity: 1,
    price: 0,
    grossTotalInCents: 0,
    sellerId: '',
    deliveryOption: DeliveryOptions.pickup,
    deliveryCostInCents: 0,
    costBeforeTaxInCents: 0,
    serviceFeeInCents: 0,
    tax: 0,
    status: OrderItemStatus.awaitingFulfillment,
  );
  final sampleOrder = OrderModel(
    orderId: '',
    billingAddress: sampleAddress,
    shippingAddress: sampleAddress,
    buyerId: '',
    orderItems: [sampleOrderItem],
    total: 0,
    timestamp: 0,
    involvedSellersList: ['mock seller 1', 'mock seller 2'],
    totalInCents: 0,
    orderStatus: OrderItemStatus.awaitingFulfillment,
  );
  group('post API', () {
    final mockPostApi = MockPostAPI();
    test(
      'returns a PostResponse if http call complete successfully',
      () async {
        when(mockPostApi.getPost('')).thenAnswer(
          (_) async => PostResponse(
            post: samplePost,
            owner: sampleUser,
          ),
        );
        expect(
          await mockPostApi.getPost(''),
          isA<PostResponse>(),
        );
      },
    );
    test('create then get post', () async {
      when(mockPostApi.createPost(userId: '', newPost: samplePost)).thenAnswer(
        (_) async => true,
      );
      when(mockPostApi.getPost('')).thenAnswer(
        (_) async => PostResponse(
          owner: sampleUser,
          post: samplePost,
        ),
      );
      expect(
        await mockPostApi.createPost(userId: '', newPost: samplePost),
        true,
      );
      expect(
        await mockPostApi.getPost(''),
        isA<PostResponse>(),
      );
    });
    test('edit then get post', () async {
      final editedPost = samplePost.copyWith(description: 'edited description');
      when(mockPostApi.updatePost(editedPost)).thenAnswer(
        (_) async => true,
      );
      when(mockPostApi.getPost('')).thenAnswer(
        (_) async => PostResponse(
          owner: sampleUser,
          post: editedPost,
        ),
      );
      expect(
        await mockPostApi.updatePost(editedPost),
        true,
      );
      expect(
        await mockPostApi.getPost(''),
        isA<PostResponse>(),
      );
    });
    test('archive post', () async {
      when(mockPostApi.archivePost('')).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockPostApi.archivePost(''),
        true,
      );
    });
    test('unarchive post', () async {
      when(mockPostApi.unarchivePost('')).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockPostApi.unarchivePost(''),
        true,
      );
    });
    test('add review', () async {
      when(mockPostApi.postReview(
        postId: '',
        review: sampleReview,
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockPostApi.postReview(
          postId: '',
          review: sampleReview,
        ),
        true,
      );
    });
    test('get review by id', () async {
      when(mockPostApi.getReviewById(postId: '', reviewId: '')).thenAnswer(
        (_) async => sampleReview,
      );
      expect(
        await mockPostApi.getReviewById(postId: '', reviewId: ''),
        isA<ReviewModel>(),
      );
    });
    test('get reviews by postId', () async {
      when(mockPostApi.getPostReviews('')).thenAnswer(
        (_) async => [sampleReview],
      );
      expect(
        await mockPostApi.getPostReviews(''),
        isA<List<ReviewModel>>(),
      );
    });
  });

  group('Cart API', () {
    final mockCartApi = MockCartAPI();
    test('add to cart', () async {
      when(mockCartApi.addToCart(
        userId: '',
        postId: '',
        quantity: 1,
        selectedVariant: '',
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockCartApi.addToCart(
          userId: '',
          postId: '',
          quantity: 1,
          selectedVariant: '',
        ),
        true,
      );
    });
    test('remove from cart', () async {
      when(mockCartApi.deleteCartItem(userId: '', cartItemId: '')).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockCartApi.deleteCartItem(userId: '', cartItemId: ''),
        true,
      );
    });
    test('get cart', () async {
      when(mockCartApi.getCart('')).thenAnswer(
        (_) async => [sampleCartItem],
      );
      expect(
        await mockCartApi.getCart(''),
        isA<List<CartItemModel>>(),
      );
    });
    test('update cart item count', () async {
      when(mockCartApi.setCartItemCount(
        userId: '',
        cartItemId: '',
        amount: 1,
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockCartApi.setCartItemCount(
          userId: '',
          cartItemId: '',
          amount: 1,
        ),
        true,
      );
    });
    test('delete cart item', () async {
      when(mockCartApi.deleteCartItem(userId: '', cartItemId: '')).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockCartApi.deleteCartItem(userId: '', cartItemId: ''),
        true,
      );
    });
  });

  group('Notifications API', () {
    final mockNotificationsApi = MockNotificationsAPI();
    test('get notifications', () async {
      when(mockNotificationsApi.getNotifications(userId: '')).thenAnswer(
        (_) async => [sampleNotification],
      );
      expect(
        await mockNotificationsApi.getNotifications(userId: ''),
        isA<List<NotificationModel>>(),
      );
    });
    test('delete notification', () async {
      when(mockNotificationsApi.clearNotifications(
        '',
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockNotificationsApi.clearNotifications(
          '',
        ),
        true,
      );
    });
  });
  group('Order API', () {
    final mockOrderApi = MockOrderAPI();
    test('create order', () async {
      when(mockOrderApi.newOrder(
        sampleAddress,
      )).thenAnswer(
        (_) async => sampleOrder,
      );
      expect(
        await mockOrderApi.newOrder(
          sampleAddress,
        ),
        isA<OrderModel>(),
      );
    });
    test('get orders', () async {
      when(mockOrderApi.getPurchasedOrders('')).thenAnswer(
        (_) async => [sampleOrder],
      );
      expect(
        await mockOrderApi.getPurchasedOrders(''),
        isA<List<OrderModel>>(),
      );
    });
    test('get order by id', () async {
      when(mockOrderApi.getSoldOrders('')).thenAnswer(
        (_) async => [sampleOrder],
      );
      expect(
        await mockOrderApi.getSoldOrders(''),
        isA<List<OrderModel>>(),
      );
    });
    test('update order status', () async {
      when(mockOrderApi.updateOrderStatus(
        orderId: '',
        newSatus: OrderItemStatus.awaitingPayment,
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockOrderApi.updateOrderStatus(
          orderId: '',
          newSatus: OrderItemStatus.awaitingPayment,
        ),
        true,
      );
    });
    test('cancel order', () async {
      when(mockOrderApi.cancelOrder('')).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockOrderApi.cancelOrder(''),
        true,
      );
    });
  });
  group('payment API', () {
    final mockPaymentApi = MockPaymentAPI();
    test('get dashboard link', () async {
      when(mockPaymentApi.getDashboardLink('')).thenAnswer(
        (_) async => '',
      );
      expect(
        await mockPaymentApi.getDashboardLink(''),
        isA<String>(),
      );
    });
    test('get payment link', () async {
      when(mockPaymentApi.isStripeSetupComplete('')).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockPaymentApi.isStripeSetupComplete(''),
        isA<bool>(),
      );
    });
    test('create account', () async {
      when(mockPaymentApi.createAccount(
        email: '',
        businessType: '',
      )).thenAnswer(
        (_) async => '',
      );
      expect(
        await mockPaymentApi.createAccount(
          email: '',
          businessType: '',
        ),
        isA<String>(),
      );
    });
    test('delete account link', () async {
      when(mockPaymentApi.deleteAccount(sellerId: '', userId: '')).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockPaymentApi.deleteAccount(sellerId: '', userId: ''),
        isA<bool>(),
      );
    });
    test('cancel and refund', () async {
      when(mockPaymentApi.cancelAndRefund(
        orderId: '',
        orderItemId: '',
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockPaymentApi.cancelAndRefund(
          orderId: '',
          orderItemId: '',
        ),
        isA<bool>(),
      );
    });
    test('get payment intent', () async {
      when(mockPaymentApi.getPaymentIntent(
        '',
      )).thenAnswer(
        (_) async => <String, dynamic>{},
      );
      expect(
        await mockPaymentApi.getPaymentIntent(
          '',
        ),
        isA<Map<String, dynamic>>(),
      );
    });
  });
  group('Report API', () {
    final mockReportApi = MockReportAPI();
    test('report user', () async {
      when(mockReportApi.reportUser(
        reportedId: '',
        reportedFor: '',
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockReportApi.reportUser(
          reportedId: '',
          reportedFor: '',
        ),
        true,
      );
    });
    test('report post', () async {
      when(mockReportApi.reportPost(
        post: samplePost,
        reportedFor: '',
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockReportApi.reportPost(
          post: samplePost,
          reportedFor: '',
        ),
        true,
      );
    });
  });
  group('Timeline API', () {
    final mockTimelineApi = MockTimelineAPI();
    test('fetch initial posts', () async {
      when(mockTimelineApi.fetchTimelinePosts(
        uid: '',
      )).thenAnswer(
        (_) async => List.generate(10, (index) => samplePostResponse),
      );
      expect(
        await mockTimelineApi.fetchTimelinePosts(
          uid: '',
        ),
        isA<List<PostResponse>>(),
      );
      expect(
        (await mockTimelineApi.fetchTimelinePosts(
          uid: '',
        ))
            .length,
        10,
      );
    });
    test('get paginated posts', () async {
      when(mockTimelineApi.fetchTimelinePosts(
        uid: '',
        lastPostId: '',
      )).thenAnswer(
        (_) async => List.generate(7, (index) => samplePostResponse),
      );
      expect(
        await mockTimelineApi.fetchTimelinePosts(
          uid: '',
          lastPostId: '',
        ),
        isA<List<PostResponse>>(),
      );
      expect(
        (await mockTimelineApi.fetchTimelinePosts(
          uid: '',
          lastPostId: '',
        ))
            .length,
        7,
      );
    });
  });
  group('User API', () {
    final mockUserApi = MockUserAPI();
    test('get user', () async {
      when(mockUserApi.getUser(
        '',
      )).thenAnswer(
        (_) async => sampleUser,
      );
      expect(
        await mockUserApi.getUser(
          '',
        ),
        isA<UserModel>(),
      );
    });
    test('delete address', () async {
      when(mockUserApi.deleteAddress(
        userId: '',
        addressId: '',
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockUserApi.deleteAddress(
          userId: '',
          addressId: '',
        ),
        true,
      );
    });
    test('update address', () async {
      when(mockUserApi.updateAddress(
        userId: '',
        addressId: '',
        address: sampleAddress,
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockUserApi.updateAddress(
          userId: '',
          addressId: '',
          address: sampleAddress,
        ),
        true,
      );
    });
    test('get all user addresses', () async {
      when(mockUserApi.getAllUserAddresses('')).thenAnswer(
        (_) async => List.generate(4, (index) => sampleAddress),
      );
      expect(
        await mockUserApi.getAllUserAddresses(''),
        isA<List<AddressModel>>(),
      );
      expect(
        (await mockUserApi.getAllUserAddresses('')).length,
        4,
      );
    });
    test('add address', () async {
      when(mockUserApi.getUserPostCount('')).thenAnswer(
        (_) async => 10,
      );
      expect(
        await mockUserApi.getUserPostCount(''),
        10,
      );
    });
    test('get all user posts initial', () async {
      when(mockUserApi.getAllUserPosts('')).thenAnswer(
        (_) async => List.generate(10, (index) => samplePost),
      );
      expect(
        await mockUserApi.getAllUserPosts(''),
        isA<List<PostModel>>(),
      );
      expect(
        (await mockUserApi.getAllUserPosts('')).length,
        10,
      );
    });
    test('get all user posts paginated', () async {
      when(mockUserApi.getAllUserPosts('', lastPostId: '')).thenAnswer(
        (_) async => List.generate(5, (index) => samplePost),
      );
      expect(
        await mockUserApi.getAllUserPosts(''),
        isA<List<PostModel>>(),
      );
      expect(
        (await mockUserApi.getAllUserPosts('', lastPostId: '')).length,
        5,
      );
    });
    test('create user', () async {
      when(mockUserApi.createUser(
        userId: '',
        user: sampleUser,
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockUserApi.createUser(
          userId: '',
          user: sampleUser,
        ),
        true,
      );
    });
    test('update user', () async {
      when(mockUserApi.updateUserDetails(
        userId: '',
        newUser: sampleUser,
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockUserApi.updateUserDetails(
          userId: '',
          newUser: sampleUser,
        ),
        true,
      );
    });
    test('add address', () async {
      when(mockUserApi.addAddress(
        userId: '',
        newAddress: sampleAddress,
      )).thenAnswer(
        (_) async => true,
      );
      expect(
        await mockUserApi.addAddress(
          userId: '',
          newAddress: sampleAddress,
        ),
        true,
      );
    });
  });
}
