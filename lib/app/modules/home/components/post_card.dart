// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/modules/profile/edit_post_view.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cartisan/app/modules/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:cartisan/app/api_classes/cart_api.dart';
import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/api_classes/report_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/home/components/custom_drop_down.dart';
import 'package:cartisan/app/modules/home/components/expandable_text.dart';
import 'package:cartisan/app/modules/home/components/product_option_dialog.dart';
import 'package:cartisan/app/modules/home/components/quantity_card.dart';
import 'package:cartisan/app/modules/profile/other_store_view.dart';
import 'package:cartisan/app/modules/share/share_bottom_sheet.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
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

  void toToOtherProfile(String userId) {
    Get.to<Widget>(OtherStoreView(userId: userId));
  }

  void buyNow() async {
    Get.dialog<Widget>(LoadingDialog(), barrierDismissible: false);
    final result = await CartAPI().addToCart(
      postId: postResponse.post.postId,
      userId: Get.find<AuthService>().currentUser!.uid,
      selectedVariant: postResponse.post.selectedVariant,
      quantity: postResponse.post.quantity,
    );
    if (result) {
      Get.back<void>();
      Get.to<Widget>(() => CartViewPages());
    } else {
      Get.back<void>();
      await showErrorDialog('Error creating order');
    }
  }

  String get currentUid => Get.find<AuthService>().currentUser!.uid;
  int get _avatarSize => 60;
  PostAPI get postApi => PostAPI();
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
                    toToOtherProfile(post.ownerId);
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
                      toToOtherProfile(post.ownerId);
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
                      onPressed: () {
                        ReportAPI().reportPost(post: post, reportedFor: '');
                      },
                      child: Text('Report'),
                    ),
                  ),
                if (post.ownerId == currentUid)
                  PopupMenuItem<dynamic>(
                    child: StatefulBuilder(builder: (context, setState) {
                      return TextButton(
                        onPressed: () async {
                          await archiveController();
                          setState(() {});
                        },
                        child: Text(post.archived ? 'Un-Archive' : 'Archive'),
                      );
                    }),
                  ),
              ]),
            ],
          ),
          SizedBox(height: 13.h),
          PostImageCarousel(images: post.images),
          SizedBox(height: AppSpacing.seventeenVertical),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    icon: SvgPicture.asset(
                      AppAssets.kCart,
                      height: 24.h,
                      width: 24.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.kWhite,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              SizedBox(width: 10.w),
              ElevatedButton(
                onPressed: (post.ownerId != currentUid && !post.archived)
                    ? buyNow
                    : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  padding: EdgeInsets.all(13.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
                  ),
                ),
                child: Text(
                  (post.ownerId != currentUid && !post.archived)
                      ? 'Buy Now | \$${NumberFormat.compact().format(post.price)}'
                      : 'Priced at | \$${NumberFormat.compact().format(post.price)}',
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
                    items: post.variants,
                    defaultValue: post.variants.first,
                    onChanged: (value) {
                      post.selectedVariant = value;
                    },
                  ),
                ),
              ],
            )
          else
            Center(
              child: PrimaryButton(
                onTap: () async {
                  final result =
                      await Get.to<PostModel>(EditPostView(post: post));
                  log(result.toString());
                  if (result != null) {
                    updatePostCallback!(result);
                  }
                },
                text: 'Edit Post',
              ),
            ),
        ],
      ),
    );
  }

  Future<void> archiveController() async {
    Get.dialog<Widget>(LoadingDialog(), barrierDismissible: false);
    bool result = false;
    if (postResponse.post.archived) {
      result = await postApi.unarchivePost(postResponse.post.postId);
    } else {
      result = await postApi.archivePost(postResponse.post.postId);
    }
    Get.back<void>();
    if (result) {
      postResponse.post.archived = !postResponse.post.archived;
    } else {
      showErrorDialog('Unable to archive');
    }
  }

  Future<void> reportPost() async {
    await Get.dialog<Widget>(const LoadingDialog());
    final result = await ReportAPI().reportPost(
      post: postResponse.post,
      reportedFor: '',
    );
    if (result) {
      Get.back<void>();
      showToast('Post Reported');
    } else {
      await showErrorDialog('Error reporting post');
    }
    Get.back<void>();
  }
}

class PostImageCarousel extends StatefulWidget {
  final List<String> images;
  const PostImageCarousel({required this.images, super.key});

  @override
  State<PostImageCarousel> createState() => _PostImageCarouselState();
}

class _PostImageCarouselState extends State<PostImageCarousel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      width: double.maxFinite,
      child: CarouselSlider.builder(
        slideBuilder: (index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(6.0.r),
            child: CachedNetworkImage(
              imageUrl: widget.images[index],
              fit: BoxFit.contain,
            ),
          );
        },
        itemCount: widget.images.length,
      ),
    );
  }
}

class ArchiveButton extends StatefulWidget {
  PostModel post;
  ArchiveButton({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  State<ArchiveButton> createState() => _ArchiveButtonState();
}

class _ArchiveButtonState extends State<ArchiveButton> {
  final PostAPI postApi = PostAPI();
  Future<void> archiveControler() async {
    Get.dialog<Widget>(LoadingDialog(), barrierDismissible: false);
    bool result = false;
    if (widget.post.archived) {
      result = await postApi.unarchivePost(widget.post.postId);
    } else {
      result = await postApi.archivePost(widget.post.postId);
    }
    Get.back<void>();
    if (result) {
      setState(() {
        widget.post.archived = !widget.post.archived;
      });
    } else {
      showErrorDialog('Unable to archive');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColors.kPrimary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: archiveControler,
        icon: Icon(
          widget.post.archived
              ? Icons.unarchive_rounded
              : Icons.archive_rounded,
          color: AppColors.kWhite,
        ),
      ),
    );
  }
}
