import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressCard extends StatelessWidget {
  final VoidCallback changeAddressCallback;
  const AddressCard({
    required this.changeAddressCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 13.w, right: 13.0.w, top: 19.h),
      decoration: BoxDecoration(
        color: AppColors.kGrey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: Colors.blue,
                child: Text(
                  'J',
                  style:
                      AppTypography.kBold20.copyWith(color: AppColors.kWhite),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jack Milan',
                      style: AppTypography.kMedium16,
                    ),
                    Text(
                      'Domen Tikoro Street:  825 Baker Avenue, Dallas,Texas, Zip code  75202',
                      style: AppTypography.kExtraLight12,
                    ),
                    Text(
                      'Phone No. 0123-735398900',
                      style: AppTypography.kExtraLight12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: CustomTextButton(
              onPressed: changeAddressCallback,
              text: 'Change Address',
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
