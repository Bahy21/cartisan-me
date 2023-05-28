import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/search/components/post_full_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchResultTile extends StatelessWidget {
  final PostModel post;

  const SearchResultTile(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.to<Widget>(() => PostFullScreen(postId: post.postId)),
      horizontalTitleGap: 10.w,
      visualDensity: const VisualDensity(vertical: 1),
      // titleAlignment: ListTileTitleAlignment.center,
      leading: CircleAvatar(
        radius: 30.r,
        backgroundColor: Colors.black,
        backgroundImage: CachedNetworkImageProvider(
          post.images.first,
        ),
      ),
      title: Text(
        post.productName,
        style: AppTypography.kBold16,
      ),
      subtitle: Text(
        post.description,
        style: AppTypography.kBold14.copyWith(color: AppColors.kGrey2),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
