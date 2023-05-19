import 'dart:developer';
import 'package:cartisan/app/api_classes/report_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/home/components/custom_drop_down.dart';
import 'package:cartisan/app/modules/home/components/expandable_text.dart';
import 'package:cartisan/app/modules/home/components/product_option_dialog.dart';
import 'package:cartisan/app/modules/home/components/quantity_card.dart';
import 'package:cartisan/app/modules/profile/other_store_view.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/modules/widgets/dialogs/success_dialog.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget {
  final PostResponse postResponse;
  final VoidCallback? addToCartCallback;
  final VoidCallback? buyNowCallback;
  final VoidCallback? reportCallback;
  const PostCard({
    required this.postResponse,
    this.addToCartCallback,
    this.reportCallback,
    super.key,
    this.buyNowCallback,
  });

  void toToOtherProfile(String userId) {
    Get.to<Widget>(OtherStoreView(userId: userId));
  }

  int get _avatarSize => 60;
  @override
  Widget build(BuildContext context) {
    final user = postResponse.owner;
    final post = postResponse.post;
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.only(
        left: 9.w,
        right: AppSpacing.eightHorizontal,
        top: AppSpacing.twelveVertical,
        bottom: AppSpacing.seventeenVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.kGrey,
        borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    if (post.ownerId !=
                        Get.find<AuthService>().currentUser!.uid) {
                      toToOtherProfile(post.ownerId);
                    }
                  },
                  child: SizedBox(
                    height: _avatarSize.w,
                    width: _avatarSize.w,
                    child: user.url.isURL
                        ? ClipOval(
                            child: Image.network(
                              user.url,
                              fit: BoxFit.cover,
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
                  )),
              SizedBox(width: 12.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    toToOtherProfile(post.ownerId);
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
              IconButton(
                onPressed: addToCartCallback,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: SvgPicture.asset(
                  AppAssets.kCart,
                  height: 24.h,
                  width: 24.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.kPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              IconButton(
                onPressed: () {
                  Get.dialog<Widget>(ProductOptionDialog(
                    reportCallback: reportPost,
                  ));
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          SizedBox(height: 13.h),
          PostImageCarousel(images: post.images),
          SizedBox(height: AppSpacing.seventeenVertical),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                post.productName,
                style: AppTypography.kBold18,
              ),
              ElevatedButton(
                onPressed: buyNowCallback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  padding: EdgeInsets.all(13.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
                  ),
                ),
                child: Text(
                  'Buy Now | ${post.price}',
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
          Row(
            children: [
              Expanded(
                flex: 6,
                child: QuantityCard(
                  quantity: post.quantity,
                  onChanged: (quantity) {
                    post.quantity = quantity;
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: CustomDropDown(
                  items: post.variants,
                  onChanged: (value) {
                    post.selectedVariant = value;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void reportPost() async {
    Get.dialog<Widget>(LoadingDialog());
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

  Widget imageWithCatch(String url) {
    try {
      return Image.network(url);
    } on Exception catch (e) {
      log(e.toString());
      return Icon(Icons.person_2_rounded, color: Colors.pink.shade800);
    }
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
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                  ));
            },
            itemCount: widget.images.length));
  }
}
