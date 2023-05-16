import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostFullScreen extends StatelessWidget {
  final String postId;
  const PostFullScreen({required this.postId, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostResponse?>(
      future: PostAPI().getPost(postId),
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
              title: Text('Error'),
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
        final postResponse = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(postResponse!.post.productName),
            leading: IconButton(
              onPressed: () => Get.back<void>(),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.kWhite,
              ),
            ),
          ),
          body: PostCard(postResponse: postResponse),
        );
      },
    );
  }
}
