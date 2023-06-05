import 'package:cartisan/app/models/delivery_options.dart';
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
  final sampleReview = ReviewModel(
    reviewID: '',
    reviewText: 'mock review text',
    rating: 0,
    reviewerName: 'mock reviewer name',
    reviewerId: '',
    timestamp: 0,
  );
  group('fetchPost', () {
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
}
