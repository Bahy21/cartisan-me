import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/controllers/post_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:cartisan/app/modules/profile/components/user_own_post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostFullScreenExternal extends StatelessWidget {
  final String postId;
  const PostFullScreenExternal({required this.postId, super.key});
  PostAPI get postAPI => PostAPI();
  PostController get pc => Get.find<PostController>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostResponse?>(
      future: postAPI.getPost(postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text('Error'),
          );
        }
        final postResponse = snapshot.data!;
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
          body: PostCard(
            postResponse: postResponse,
          ),
        );
      },
    );
  }
}
