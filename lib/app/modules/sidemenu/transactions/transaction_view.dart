import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/sidemenu/transactions/components/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction', style: AppTypography.kLight18),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(height: 43.h),
          Text(
            'Latest Transaction',
            style:
                AppTypography.kMedium16.copyWith(color: AppColors.kHintColor),
          ),
          SizedBox(height: 28.h),
          ListView.separated(
            itemBuilder: (context, index) {
              return const TransactionCard();
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemCount: 3,
          ),
          SizedBox(height: 28.01.h),
          Text(
            'Previous Transaction',
            style: AppTypography.kMedium16
                .copyWith(color: AppColors.kHintColor, fontSize: 16.sp),
          ),
          SizedBox(height: 28.0.h),
          ListView.separated(
            itemBuilder: (context, index) {
              return const TransactionCard();
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemCount: 1,
          ),
        ],
      ),
    );
  }
}
