import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/profile/components/custom_outlined_button.dart';
import 'package:cartisan/app/modules/profile/components/profile_info_column.dart';
import 'package:cartisan/app/services/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCard extends StatelessWidget {
  final VoidCallback editCallback;
  final VoidCallback? followCallback;
  final VoidCallback? chatCallback;
  final bool isProfileOwner;
  const ProfileCard({
    required this.editCallback,
    required this.isProfileOwner,
    this.followCallback,
    this.chatCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 81.h,
          width: 81.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                'https://randomuser.me/api/portraits/men/81.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileInfoColumn(
                    numbers: '103',
                    headings: TranslationsService.storePageTranslation.posts,
                  ),
                  ProfileInfoColumn(
                    numbers: '1.2k',
                    headings:
                        TranslationsService.storePageTranslation.followers,
                  ),
                  ProfileInfoColumn(
                    numbers: '1.2k',
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
