import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/profile/components/user_post_full_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserExploreCard extends StatelessWidget {
  final PostModel post;
  const UserExploreCard({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to<Widget>(() => UserPostFullScreen(post: post));
      },
      child: Container(
        decoration: BoxDecoration(
          image: post.images.first.isURL
              ? DecorationImage(
                  image: NetworkImage(post.images.first),
                  fit: BoxFit.cover,
                )
              : null,
          color: AppColors.kGrey2,
        ),
      ),
    );
  }
}
