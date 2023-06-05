import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TransactionCard extends StatelessWidget {
  const TransactionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.kGrey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: AppColors.kPrimary,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jesica Frenanz',
                            style: AppTypography.kMedium14,
                          ),
                          SizedBox(height: 4.0.h),
                          Text(
                            'Thrift Store',
                            style: AppTypography.kLight14
                                .copyWith(color: AppColors.kHintColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          r'+ $ 75.34',
                          style: AppTypography.kMedium16.copyWith(
                            color: AppColors.kPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Received',
                          style: AppTypography.kExtraLight12
                              .copyWith(color: AppColors.kHintColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              );
  }
}