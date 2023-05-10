import 'package:animate_do/animate_do.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/home/components/custom_drop_down.dart';
import 'package:cartisan/app/modules/home/components/expandable_text.dart';
import 'package:cartisan/app/modules/home/components/product_option_dialog.dart';
import 'package:cartisan/app/modules/home/components/quantity_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget {
  final int index;
  final PostModel post;
  final VoidCallback? addToCartCallback;
  final VoidCallback? buyNowCallback;
  final VoidCallback? reportCallback;
  int quantity = 0;
  PostCard({
    required this.index,
    required this.post,
    this.addToCartCallback,
    this.reportCallback,
    super.key,
    this.buyNowCallback,
  });
  final uc = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: uc.fetchUser(post.ownerId),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (snapshot.data == null) {
          return const Center(
            child: Icon(Icons.error),
          );
        }
        final user = snapshot.data!;
        return FadeInUp(
          delay: Duration(milliseconds: index * 50),
          duration: Duration(milliseconds: (index * 50) + 800),
          child: Container(
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
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: AppColors.kPrimary,
                      child: user.url.isURL
                          ? ClipOval(child: Image.network(user.url))
                          : Text(
                              user.username,
                              style: AppTypography.kMedium18
                                  .copyWith(color: AppColors.kWhite),
                            ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
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
                        Get.dialog<void>(ProductOptionDialog(
                          reportCallback: reportCallback!,
                        ));
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                SizedBox(height: 13.h),
                Container(
                  height: 168.h,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0.r),
                    image: DecorationImage(
                      image: NetworkImage(post.images.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                          borderRadius:
                              BorderRadius.circular(AppSpacing.sixRadius),
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
                        onChanged: (quantity) {
                          quantity = quantity;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: CustomDropDown(
                        items: post.variants,
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
