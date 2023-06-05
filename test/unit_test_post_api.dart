import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/models/review_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> unitTestPostApi() async {
  final postApi = PostAPI();

  test('get first post', () async {
    final result =
        await postApi.getPost('27924507-0a28-406e-b828-275e9fc14f83');
    expect(result, isA<PostResponse>());
    expect(result?.post, isA<PostModel>());
    expect(result?.owner, isA<UserModel>());
  });
  test('delete post', () async {
    final archiveResult =
        await postApi.archivePost('27924507-0a28-406e-b828-275e9fc14f83');
    expect(archiveResult, isA<bool>());
    expect(archiveResult, true);
    final latestPost =
        await postApi.getPost('27924507-0a28-406e-b828-275e9fc14f83');
    expect(latestPost?.post.archived, true);
    final unarchiveResult =
        await postApi.unarchivePost('27924507-0a28-406e-b828-275e9fc14f83');
    expect(unarchiveResult, isA<bool>());
    expect(unarchiveResult, true);
    final updatedPost =
        await postApi.getPost('27924507-0a28-406e-b828-275e9fc14f83');
    expect(updatedPost?.post.archived, false);
  });
  test('get review', () async {
    final testReview = ReviewModel(
      reviewID: '',
      reviewText: 'test review',
      rating: 5,
      reviewerName: 'test',
      reviewerId: '',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    // final result = await postApi.createReview(
    //   postId: '27924507-0a28-406e-b828-275e9fc14f83',
    //   newReview: testReview,
    // );
    // expect(result, isA<bool>());
    // expect(result, true);
    final getReview =
        await postApi.getPostReviews('27924507-0a28-406e-b828-275e9fc14f83');
    expect(getReview, isA<List<ReviewModel>>());
    expect(getReview.last.reviewText, testReview.reviewText);
    expect(getReview.last.reviewerName, testReview.reviewerName);
  });
  test('get,update post and return to original', () async {
    final result =
        await postApi.getPost('27924507-0a28-406e-b828-275e9fc14f83');
    expect(result, isA<PostResponse>());
    final originalPost = result!.post;
    final updatedPost = originalPost.copyWith(
      productName: 'updated title',
      description: 'updated description',
    );
    final updateResult = await postApi.updatePost(updatedPost);
    expect(updateResult, isA<bool>());
    expect(updateResult, true);
    final updatedPostResponse =
        await postApi.getPost('27924507-0a28-406e-b828-275e9fc14f83');
    expect(updatedPostResponse, isA<PostResponse>());
    expect(updatedPostResponse?.post, updatedPost);
    final revertResult = await postApi.updatePost(originalPost);
    expect(revertResult, isA<bool>());
    expect(revertResult, true);
    final revertedPostResponse =
        await postApi.getPost('27924507-0a28-406e-b828-275e9fc14f83');
    expect(revertedPostResponse, isA<PostResponse>());
    expect(revertedPostResponse?.post, originalPost);
  });
}
