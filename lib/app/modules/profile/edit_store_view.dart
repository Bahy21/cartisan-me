import 'dart:developer';

import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/profile/components/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditStoreView extends StatelessWidget {
  EditStoreView({super.key});
  final UserController uc = Get.find<UserController>();
  final _avatarSize = 90;
  @override
  Widget build(BuildContext context) {
    log(uc.currentUser.toString());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back<void>();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Edit Profile', style: AppTypography.kLight18),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                log('stripe button pressed');
                // TODO: ADD STRIPE.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Text(
                'Connect to Stipe',
                style: AppTypography.kLight15,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Center(
            child: Container(
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.kPrimary),
                shape: BoxShape.circle,
              ),
              child: SizedBox(
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
            ),
          ),
          SizedBox(height: 17.h),
          Text(uc.currentUser?.username ?? 'New User',
              style: AppTypography.kMedium16),
          Text(
            uc.currentUser?.email ?? 'email',
            style:
                AppTypography.kMedium14.copyWith(color: AppColors.kHintColor),
          ),
        ],
      ),
      bottomSheet: const CustomBottomSheet(),
    );
  }
}
