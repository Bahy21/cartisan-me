import 'dart:developer';

import 'package:cartisan/app/controllers/store_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/profile/components/custom_outlined_button.dart';
import 'package:cartisan/app/modules/profile/components/profile_info_column.dart';
import 'package:cartisan/app/services/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtherStoreProfileCard extends StatelessWidget {
  final VoidCallback? chatCallback;
  OtherStoreProfileCard({
    this.chatCallback,
    super.key,
  });
  final spc = Get.find<StorePageController>();
  final _avatarSize = 81;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: _avatarSize.w,
              width: _avatarSize.w,
              child: spc.storeOwner?.url.isURL ?? false
                  ? ClipOval(
                      child: Image.network(
                        spc.storeOwner!.url,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        child: Transform.translate(
                          offset: Offset(-8.w, 0),
                          child: Icon(
                            Icons.person,
                            size: 100.w,
                            color: AppColors.kPrimary,
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(width: 16.w),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProfileInfoColumn(
                        numbers: spc.postCount.toString(),
                        headings:
                            TranslationsService.storePageTranslation.posts,
                      ),
                      ProfileInfoColumn(
                        numbers:
                            spc.storeOwner?.followerCount.toString() ?? '0',
                        headings:
                            TranslationsService.storePageTranslation.followers,
                      ),
                      ProfileInfoColumn(
                        numbers:
                            spc.storeOwner?.followingCount.toString() ?? '0',
                        headings:
                            TranslationsService.storePageTranslation.following,
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomOutlinedButton(
                          onTap: spc.followUser,
                          text: spc.isFollowing
                              ? TranslationsService
                                  .storePageTranslation.following
                              : TranslationsService.storePageTranslation.follow,
                          btnColor: AppColors.kPrimary,
                          color: AppColors.kPrimary,
                          fontColor: AppColors.kWhite,
                        ),
                      ),
                      SizedBox(width: 13.w),
                      Expanded(
                        child: CustomOutlinedButton(
                          onTap: chatCallback ??
                              () => log('no chat function assigned or found'),
                          text: TranslationsService.storePageTranslation.chat,
                          color: AppColors.kPrimary,
                          fontColor: AppColors.kPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
