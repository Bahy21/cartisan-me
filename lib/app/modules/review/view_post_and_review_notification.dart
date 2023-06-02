import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/models/review_model.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:cartisan/app/modules/review/review_card.dart';
import 'package:cartisan/app/modules/search/components/post_full_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPostAndReviewNotification extends StatefulWidget {
  final String postId;
  final String reviewId;
  const ViewPostAndReviewNotification({
    required this.postId,
    required this.reviewId,
    super.key,
  });

  @override
  State<ViewPostAndReviewNotification> createState() =>
      _ViewPostAndReviewNotificationState();
}

class _ViewPostAndReviewNotificationState
    extends State<ViewPostAndReviewNotification> {
  final postApi = PostAPI();

  @override
  void initState() {
    super.initState();
    getPostWithReview();
  }

  Future<Map<String, dynamic>?> getPostWithReview() async {
    final postResponse = await postApi.getPost(widget.postId);
    final review = await postApi.getReviewById(
      postId: widget.postId,
      reviewId: widget.reviewId,
    );
    if (postResponse == null || review == null) return null;
    return <String, dynamic>{
      'postResponse': postResponse,
      'review': review,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getPostWithReview(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              leading: IconButton(
                onPressed: () => Get.back<void>(),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.kWhite,
                ),
              ),
            ),
            body: const Center(
              child: Text('Post not found\n Please try later'),
            ),
          );
        }
        final postResponse = snapshot.data!['postResponse'] as PostResponse;
        final review = snapshot.data!['review'] as ReviewModel;
        return Scaffold(
          appBar: AppBar(
            title: Text(postResponse.post.productName),
            leading: IconButton(
              onPressed: () => Get.back<void>(),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.kWhite,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                PostCard(postResponse: postResponse),
                SizedBox(
                  height: AppSpacing.fourteenVertical,
                ),
                ReviewCard(review: review),
              ],
            ),
          ),
        );
      },
    );
  }
}
