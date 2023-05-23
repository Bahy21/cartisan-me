import 'package:cached_network_image/cached_network_image.dart';
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
          image: DecorationImage(
            image: CachedNetworkImageProvider(post.images.first),
            fit: BoxFit.cover,
          ),
          color: Colors.red,
        ),
      ),
    );
  }
}
