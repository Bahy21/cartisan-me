const BASE_URL =
    'https://us-central1-cloud-function-practice-f911f.cloudfunctions.net/app/v1/api';

class ApiCalls {
  GetApiCalls getApiCalls = GetApiCalls();
  PostApiCalls postApiCalls = PostApiCalls();
  PutApiCalls putApiCalls = PutApiCalls();
  DeleteApiCalls deleteApiCalls = DeleteApiCalls();
}

class GetApiCalls {
  String getTimeline(String userId, {int count = 10}) =>
      '$BASE_URL/timeline/fetchPosts/$userId/$count';

  String getOrderItems(String orderId) => '$BASE_URL/order/getOrders/$orderId';
  String getNotifications(String userId) =>
      '$BASE_URL/notifications/getNotifications/$userId';
  String getSearches(String userId, {int count = 20}) =>
      '$BASE_URL/search/fetchPosts/$userId/$count';
}

class PostApiCalls {
  String createPost(String userId) => '$BASE_URL/newPost/$userId';
  String createReview(String postId) => '$BASE_URL/review/postReview/$postId';
  String createComment(String postId) =>
      '$BASE_URL/post/comments/newComment/$postId';
  String createOrder(String userId) => '$BASE_URL/order/newOrder/$userId';
  String get populate => '$BASE_URL/populateFirebase';
}

class PutApiCalls {
  String blockUser({required String blockerId, required String blockedId}) =>
      '$BASE_URL/social/blockUser/$blockerId/$blockedId';

  String likePost({required String userId, required String postId}) =>
      '$BASE_URL/post/likePost/$userId/$postId';
  String updateOrderStatus(String orderId) =>
      '$BASE_URL/order/updateOrderStatus/$orderId';
  String updateOrderItemStatus(String orderId) =>
      '$BASE_URL/order/updateOrderItemStatus/$orderId';
}

class DeleteApiCalls {
  String deletePost(String postId) => '$BASE_URL/post/deletePost/$postId';

  String unblockUser({required String blockerId, required String blockedId}) =>
      '$BASE_URL/social/unblockUser/$blockerId/$blockedId';

  String clearCart(String userId) => '$BASE_URL/cart/clearCart/$userId';
  String unlikePost({required String userId, required String postId}) =>
      '$BASE_URL/post/unlikePost/$userId/$postId';
  String deleteComment({required String postId, required String commentId}) =>
      '$BASE_URL/post/comments/deleteComment/$postId/$commentId';
  String cancelOrder(String orderId) => '$BASE_URL/order/deleteOrder/$orderId';
}
