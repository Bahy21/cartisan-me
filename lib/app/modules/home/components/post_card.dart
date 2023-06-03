// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/controllers/post_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/home/components/custom_drop_down.dart';
import 'package:cartisan/app/modules/home/components/expandable_text.dart';
import 'package:cartisan/app/modules/home/components/quantity_card.dart';
import 'package:cartisan/app/modules/profile/edit_post_view.dart';
import 'package:cartisan/app/modules/review/see_all_reviews.dart';
import 'package:cartisan/app/modules/share/share_bottom_sheet.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cartisan/app/modules/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget {
  final PostResponse postResponse;
  final VoidCallback? addToCartCallback;
  final VoidCallback? buyNowCallback;
  final VoidCallback? reportCallback;
  final Function(PostModel)? updatePostCallback;
  const PostCard({
    required this.postResponse,
    this.addToCartCallback,
    this.reportCallback,
    this.buyNowCallback,
    this.updatePostCallback,
    super.key,
  });

  PostController get pc => Get.find<PostController>();
  TimelineController get tc => Get.find<TimelineController>();
  String get currentUid => Get.find<AuthService>().currentUser!.uid;
  int get _avatarSize => 60;
  @override
  Widget build(BuildContext context) {
    final user = postResponse.owner;
    var post = postResponse.post;
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.h,
      ),
      padding: EdgeInsets.only(
        left: 9.w,
        right: AppSpacing.eightHorizontal,
        top: AppSpacing.twelveVertical,
        bottom: AppSpacing.seventeenVertical,
      ),
      decoration: const BoxDecoration(
        color: AppColors.kGrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (post.ownerId != currentUid) {
                    pc.toToOtherProfile(post.ownerId);
                  }
                },
                child: SizedBox(
                  height: _avatarSize.w,
                  width: _avatarSize.w,
                  child: user.url.isURL
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user.url,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, dynamic error) =>
                                ClipOval(
                              child: Material(
                                child: Transform.translate(
                                  offset: Offset(-8.w, 0),
                                  child: Icon(
                                    Icons.person,
                                    size: 80.w,
                                    color: AppColors.kPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : ClipOval(
                          child: Material(
                            child: Transform.translate(
                              offset: Offset(-8.w, 0),
                              child: Icon(
                                Icons.person,
                                size: 80.w,
                                color: AppColors.kPrimary,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (post.ownerId != currentUid) {
                      pc.toToOtherProfile(post.ownerId);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: AppTypography.kBold14,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        post.location,
                        style: AppTypography.kBold14
                            .copyWith(color: AppColors.kHintColor),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  shareProduct(post);
                },
                child: Icon(
                  Icons.share,
                  color: AppColors.kWhite,
                ),
              ),
              SizedBox(width: 10.w),
              buildPopupMenu(<PopupMenuItem>[
                if (post.ownerId != currentUid)
                  PopupMenuItem<dynamic>(
                    child: TextButton(
                      onPressed: () => pc.reportPost(postResponse),
                      child: Text(
                        'Report',
                        style: AppTypography.kMedium14.copyWith(
                          color: AppColors.kWhite,
                        ),
                      ),
                    ),
                  ),
                if (post.ownerId == currentUid) ...[
                  PopupMenuItem<dynamic>(
                    child: StatefulBuilder(builder: (context, setState) {
                      return ListTile(
                        onTap: () async {
                          final result =
                              await pc.archiveController(postResponse);
                          if (result) {
                            setState(() {
                              post.archived = !post.archived;
                            });
                          }
                        },
                        title: Text(
                          post.archived ? 'Un-Archive' : 'Archive',
                          style: AppTypography.kMedium14.copyWith(
                            color: AppColors.kWhite,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      );
                    }),
                  ),
                  PopupMenuItem<dynamic>(
                    child: ListTile(
                      onTap: () async {
                        Get.back<void>();
                        final result =
                            await Get.to<PostModel>(EditPostView(post: post));
                        if (result != null) {
                          updatePostCallback!(result);
                        }
                      },
                      title: Text(
                        'Edit',
                        style: AppTypography.kMedium14.copyWith(
                          color: AppColors.kWhite,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                ],
              ]),
            ],
          ),
          SizedBox(height: 13.h),
          InkWell(
            onDoubleTap: () => tc.handleLikeUnlike(post.postId),
            child: PostImageCarousel(images: post.images),
          ),
          SizedBox(height: AppSpacing.seventeenVertical),
          PostControls(
            postId: post.postId,
          ),
          BuildPostMetadata(
            post: post,
            buyNowCallback: () => pc.buyNow(postResponse),
            addToCartCallback: () => pc.addToCart(
              postId: post.postId,
              selectedVariant: post.postId,
              quantity: post.quantity,
            ),
          ),
        ],
      ),
    );
  }
}

class PostImageCarousel extends StatelessWidget {
  final List<String> images;
  const PostImageCarousel({required this.images, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 250.h, maxHeight: 450.h),
      width: double.maxFinite,
      child: CarouselSlider.builder(
        unlimitedMode: images.length > 1,
        slideBuilder: (index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(6.0.r),
            child: CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.contain,
              width: Get.width,
            ),
          );
        },
        itemCount: images.length,
      ),
    );
  }
}

class PostControls extends StatelessWidget {
  final String postId;
  const PostControls({
    required this.postId,
    super.key,
  });
  TimelineController get tc => Get.find<TimelineController>();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => IconButton(
            onPressed: () => tc.handleLikeUnlike(postId),
            icon: tc.likes[postId] == true
                ? Icon(
                    Icons.favorite,
                    color: AppColors.kPrimary,
                  )
                : Icon(Icons.favorite_border_outlined),
          ),
        ),
        IconButton(
          onPressed: () {
            Get.to<Widget>(() => SeeAllReviews(postId: postId));
          },
          icon: Icon(Icons.reviews_outlined),
        ),
      ],
    );
  }
}

class BuildPostMetadata extends StatelessWidget {
  final PostModel post;
  final void Function()? addToCartCallback;
  final Function(PostModel)? updatePostCallback;
  final VoidCallback buyNowCallback;

  final currentUid = Get.find<AuthService>().currentUser!.uid;

  BuildPostMetadata({
    required this.post,
    required this.buyNowCallback,
    this.addToCartCallback,
    this.updatePostCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              post.productName,
              style: AppTypography.kBold18,
            ),
            const Spacer(),
            if (post.ownerId != currentUid && !post.archived)
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: addToCartCallback,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.add_shopping_cart_outlined),
                ),
              ),
            SizedBox(width: 10.w),
            ElevatedButton(
              onPressed: (post.ownerId != currentUid) ? buyNowCallback : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                padding: EdgeInsets.all(13.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
                ),
              ),
              child: Text(
                (post.ownerId != currentUid && !post.archived)
                    ? 'Buy Now | ${NumberFormat.compactSimpleCurrency().format(post.price)}'
                    : 'Priced at | ${NumberFormat.compactSimpleCurrency().format(post.price)}',
                style: AppTypography.kBold14,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text('Description:', style: AppTypography.kBold14),
        SizedBox(height: 11.h),
        ExpandableText(text: post.description),
        SizedBox(height: 14.h),
        if (post.ownerId != currentUid)
          Row(
            children: [
              Expanded(
                flex: 6,
                child: QuantityCard(
                  quantity: post.quantity < 1 ? 1 : post.quantity,
                  onChanged: (quantity) {
                    post.quantity = quantity;
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: CustomDropDown(
                  items: Set<String>.from(post.variants).toList(),
                  defaultValue: post.variants.first,
                  onChanged: (value) {
                    post.selectedVariant = value;
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
}
