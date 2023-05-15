import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreCard extends StatelessWidget {
  final SearchModel post;
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
          image: post.imageUrl.isURL
              ? DecorationImage(
                  image: NetworkImage(post.imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
          color: AppColors.kGrey2,
        ),
      ),
    );
  }
}
