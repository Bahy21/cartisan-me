class ApiCalls{
  static String apiRoot =
    'http://10.0.2.2:5001/cloud-function-practice-f911f/us-central1/app/v1';

  GetApiCalls getApiCalls = GetApiCalls();
  PostApiCalls postApiCalls = PostApiCalls();
  PutApiCalls putApiCalls = PutApiCalls();
  DeleteApiCalls deleteApiCalls = DeleteApiCalls();
}



class GetApiCalls{
  static String createUser(String userId)=> '/api/user/getUser/$userId';
  static String getAllUserPosts(String userId)=> '/api/user/getAllPosts/$userId';
  static String getPost(String postId) => '/api/post/getPost/$postId';
  static String isFollowing({required String userId, required String followId}) => '/api/social/isFollowing/$userId/$followId';
  static String getFollowing(String userId) => '/api/social/getFollowing/$userId';
  static String getFollowers(String userId) => '/api/social/getFollowers/$userId';
  static String isBlocked({required String blockerId, required String blockedId}) => '/api/social/isBlocked/$blockerId/$blockedId'
  static String getBlockList(String userId) => '/api/social/getBlockList/$userId';
  static String getPostsFromCart(String userId) => 'api/user/getPostsFromCart/$userId';
  static String getCart(String userId) => 'api/user/getCart/$userId';
  static String getTimeline(String userId) => '/api/timeline/fetchPosts/$userId';
  static String isLiked({required String userId, required String postId}) => '/api/social/isLiked/$userId/$postId';
  static String getLikes(String postId) => '/api/social/getLikes/$postId';
  static String getComments(String postId) => '/api/post/comments/getComments/$postId';
  static String getOrderItems(String orderId) => '/api/order/getOrders/$orderId';
}
class PostApiCalls{
  static String createUser(String userId) => '/api/user/createUser/$userId';
  static String createPost(String userId) => '/api/newPost/$userId';
  static String createReview(String postId) => '/api/review/postReview/$postId';
  static String createComment(String postId) => '/api/post/comments/newComment/$postId';
  static String createOrder(String userId) => '/api/order/newOrder/$userId';
}

class PutApiCalls{
  static String addAddress(String userId) => '/api/user/addAddress/$userId';
  static String updateArea(String userId) => '/api/user/updateArea/$userId';
  static String updateDeliveryInfo(String userId) => '/api/user/updateDeliveryInfo/$userId';
  static String followUser({required String userId, required String followId}) => '/api/user/followUser/$userId/$followId';
  static String blockUser({required String blockerId, required String blockedId}) => '/api/social/blockUser/$blockerId/$blockedId';
  static String addToCart({required String postId, required String userId}) => '/api/cart/addToCart/$userId/$postId';
  static String likePost({required String userId, required String postId}) => '/api/post/likePost/$userId/$postId';
  static String updateOrderStatus(String orderId) => '/api/order/updateOrderStatus/$orderId';
  static String updateOrderItemStatus(String orderId) => '/api/order/updateOrderItemStatus/$orderId';

}

class DeleteApiCalls{
  static String deletePost(String uid) => '/api/post/deletePost/$postId';
  static String unfollowUser(String uid) => '/api/user/unfollowUser/$userId';
  static String unblockUser({required String blockerId, required String blockedId}) =>'/api/social/unblockUser/$blockerId/$blockedId'
  static String deleteFromCart({required String postId, required String uid}) => '/api/cart/deleteFromCart/$userId/$postId';
  static String clearCart(String uid) => '/api/cart/clearCart/$userId';
  static String unlikePost({required String userId, required String postId}) => '/api/post/unlikePost/$userId/$postId';
  static String deleteComment({required String postId, required String commentId}) =>'/api/post/comments/deleteComment/$postId/$commentId';
  static String cancelOrder(String orderId) => '/api/order/deleteOrder/$orderId';
}




