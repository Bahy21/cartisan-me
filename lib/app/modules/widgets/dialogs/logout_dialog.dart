import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback logoutCallback;
  const LogoutDialog({
    required this.logoutCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.tenRadius),
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: AppSpacing.twentyVertical),
          Text('Log Out', style: AppTypography.kBold20),
          SizedBox(height: AppSpacing.twentyVertical),
          Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: AppTypography.kLight14,
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: Get.back,
                  child: Container(
                    height: 50.h,
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel',
                      style: AppTypography.kMedium16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    logoutCallback();
                    Get.back<void>();
                  },
                  child: Container(
                    height: 50.0.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(AppSpacing.tenRadius),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style:
                          AppTypography.kMedium16.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
