import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;
  const ExploreCard({
    required this.post,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
