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
  ProfileCard({
    required this.editCallback,
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
        Obx(
          () => Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ProfileInfoColumn(
                      numbers: uc.userPostCount.toString(),
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
                CustomOutlinedButton(
                  onTap: editCallback,
                  text: TranslationsService.storePageTranslation.editProfile,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
