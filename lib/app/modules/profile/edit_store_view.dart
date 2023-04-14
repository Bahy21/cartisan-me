import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/profile/components/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditStoreView extends StatelessWidget {
  const EditStoreView({super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
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
              child: Container(
                height: 90.h,
                width: 90.w,
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
            ),
          ),
          SizedBox(height: 17.h),
          Text('Thrift Store', style: AppTypography.kMedium16),
          Text(
            'Thriftstore@example.com',
            style:
                AppTypography.kMedium14.copyWith(color: AppColors.kHintColor),
          ),
        ],
      ),
      bottomSheet: const CustomBottomSheet(),
    );
  }
}
