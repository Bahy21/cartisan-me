import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/notification/components/notification_card.dart';
import 'package:cartisan/app/modules/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPageView extends StatelessWidget {
  const NotificationPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: AppTypography.kLight18,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        children: [
          Row(
            children: [
              Text(
                'All Updates',
                style:
                    AppTypography.kMedium16.copyWith(color: AppColors.kGrey2),
              ),
              const Spacer(),
              CustomTextButton(
                onPressed: () {},
                text: 'Clear All',
                fontSize: 12.sp,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              return const NotificationCard();
            },
          ),
        ],
      ),
    );
  }
}
