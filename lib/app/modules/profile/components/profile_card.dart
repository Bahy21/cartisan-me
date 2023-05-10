import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/profile/components/custom_outlined_button.dart';
import 'package:cartisan/app/modules/profile/components/profile_info_column.dart';
import 'package:cartisan/app/services/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileCard extends StatelessWidget {
  final VoidCallback editCallback;
  final VoidCallback? followCallback;
  final VoidCallback? chatCallback;
  final bool isProfileOwner;
  ProfileCard({
    required this.editCallback,
    required this.isProfileOwner,
    this.followCallback,
    this.chatCallback,
    super.key,
  });
  final uc = Get.find<UserController>();
  final _avatarSize = 81;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: _avatarSize.w,
          width: _avatarSize.w,
          child: uc.currentUser?.url.isURL ?? false
              ? ClipOval(
                  child: Image.network(
                    uc.currentUser!.url,
                    fit: BoxFit.cover,
                  ),
                )
              : ClipOval(
                  child: Material(
                    child: Icon(
                      Icons.person,
                      size: 100.w,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
          // TODO: FUCKING CENTER THAT ICON.
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileInfoColumn(
                    numbers: uc.currentUser?.isSeller ?? false ? 'NaN' : '0',
                    headings: TranslationsService.storePageTranslation.posts,
                  ),
                  ProfileInfoColumn(
                    numbers: uc.currentUser?.followerCount.toString() ?? '0',
                    headings:
                        TranslationsService.storePageTranslation.followers,
                  ),
                  ProfileInfoColumn(
                    numbers: uc.currentUser?.followingCount.toString() ?? '0',
                    headings:
                        TranslationsService.storePageTranslation.following,
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              if (isProfileOwner)
                CustomOutlinedButton(
                  onTap: editCallback,
                  text: TranslationsService.storePageTranslation.editProfile,
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        onTap: () {},
                        text: TranslationsService.storePageTranslation.follow,
                        btnColor: AppColors.kPrimary,
                        color: AppColors.kPrimary,
                        fontColor: AppColors.kWhite,
                      ),
                    ),
                    SizedBox(width: 13.w),
                    Expanded(
                      child: CustomOutlinedButton(
                        onTap: () {},
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
    );
  }
}
