const String apiRoot =
    'https://us-central1-cloud-function-practice-f911f.cloudfunctions.net/app';

class ApiCalls {
  GetApiCalls getApiCalls = GetApiCalls();
  PostApiCalls postApiCalls = PostApiCalls();
  PutApiCalls putApiCalls = PutApiCalls();
  DeleteApiCalls deleteApiCalls = DeleteApiCalls();
}

class GetApiCalls {
  String getUser(String userId) => '$apiRoot/api/user/getUser/$userId';
  String getAllUserPosts(String userId) =>
      '$apiRoot/api/user/getAllPosts/$userId';
  String getPost(String postId) => '$apiRoot/api/post/getPost/$postId';
  String isFollowing({required String userId, required String followId}) =>
      '$apiRoot/api/social/isFollowing/$userId/$followId';
  String getFollowing(String userId) =>
      '$apiRoot/api/social/getFollowing/$userId';
  String getFollowers(String userId) =>
      '$apiRoot/api/social/getFollowers/$userId';
  String isBlocked({required String blockerId, required String blockedId}) =>
      '$apiRoot/api/social/isBlocked/$blockerId/$blockedId';
  String getBlockList(String userId) =>
      '$apiRoot/api/social/getBlockList/$userId';
  String getPostsFromCart(String userId) =>
      '/api/user/getPostsFromCart/$userId';
  String getCart(String userId) => '$apiRoot/api/user/getCart/$userId';
  String getTimeline(String userId, {int count = 10}) =>
      '$apiRoot/api/timeline/fetchPosts/$userId/$count';
  String isLiked({required String userId, required String postId}) =>
      '$apiRoot/api/social/isLiked/$userId/$postId';
  String getLikes(String postId) => '$apiRoot/api/social/getLikes/$postId';
  String getComments(String postId) =>
      '$apiRoot/api/post/comments/getComments/$postId';
  String getOrderItems(String orderId) =>
      '$apiRoot/api/order/getOrders/$orderId';
  String getNotifications(String userId) =>
      '$apiRoot/api/notifications/getNotifications/$userId';
  String getSearches(String userId, {int count = 20}) =>
      '$apiRoot/api/search/fetchPosts/$userId/$count';
}

class PostApiCalls {
  String createUser(String userId) => '$apiRoot/api/user/createUser/$userId';
  String createPost(String userId) => '$apiRoot/api/newPost/$userId';
  String createReview(String postId) =>
      '$apiRoot/api/review/postReview/$postId';
  String createComment(String postId) =>
      '$apiRoot/api/post/comments/newComment/$postId';
  String createOrder(String userId) => '$apiRoot/api/order/newOrder/$userId';
  String get populate => '$apiRoot/populateFirebase';
}

class PutApiCalls {
  String addAddress(String userId) => '$apiRoot/api/user/addAddress/$userId';
  String updateArea(String userId) => '$apiRoot/api/user/updateArea/$userId';
  String updateDeliveryInfo(String userId) =>
      '$apiRoot/api/user/updateDeliveryInfo/$userId';
  String followUser({required String userId, required String followId}) =>
      '$apiRoot/api/user/followUser/$userId/$followId';
  String blockUser({required String blockerId, required String blockedId}) =>
      '$apiRoot/api/social/blockUser/$blockerId/$blockedId';
  String addToCart({required String postId, required String userId}) =>
      '$apiRoot/api/user/addToCart/$userId/$postId';
  String likePost({required String userId, required String postId}) =>
      '$apiRoot/api/post/likePost/$userId/$postId';
  String updateOrderStatus(String orderId) =>
      '$apiRoot/api/order/updateOrderStatus/$orderId';
  String updateOrderItemStatus(String orderId) =>
      '$apiRoot/api/order/updateOrderItemStatus/$orderId';
  String updateUserDetails(String userId) =>
      '$apiRoot/api/user/updateUser/$userId';
  String setCartItemCount({
    required String userId,
    required String cartItemId,
  }) =>
      '$apiRoot/api/user/setCartItemCount/$userId/$cartItemId';
  String decrementCartItem({
    required String userId,
    required String cartItemId,
  }) =>
      '$apiRoot/api/user/decrementCartItem/$userId/$cartItemId';
}

class DeleteApiCalls {
  String deletePost(String postId) => '$apiRoot/api/post/deletePost/$postId';
  String unfollowUser({required String userId, required String followId}) =>
      '$apiRoot/api/user/unfollowUser/$userId/$followId';
  String unblockUser({required String blockerId, required String blockedId}) =>
      '$apiRoot/api/social/unblockUser/$blockerId/$blockedId';
  String deleteCartItem({required String itemId, required String userId}) =>
      '$apiRoot/api/user/deleteFromCart/$userId/$itemId';
  String clearCart(String userId) => '$apiRoot/api/cart/clearCart/$userId';
  String unlikePost({required String userId, required String postId}) =>
      '$apiRoot/api/post/unlikePost/$userId/$postId';
  String deleteComment({required String postId, required String commentId}) =>
      '$apiRoot/api/post/comments/deleteComment/$postId/$commentId';
  String cancelOrder(String orderId) =>
      '$apiRoot/api/order/deleteOrder/$orderId';
}
