import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/profile/components/user_own_post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPostFullScreen extends StatelessWidget {
  final PostModel post;
  const UserPostFullScreen({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.productName),
        leading: IconButton(
          onPressed: () => Get.back<void>(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.kWhite,
          ),
        ),
      ),
      body: UserOwnPostCard(post: post),
    );
  }
}
