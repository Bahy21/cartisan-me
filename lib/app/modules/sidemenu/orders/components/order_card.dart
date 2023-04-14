import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/dotted_line_divider.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/order_receipts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.kGrey,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://cdn.shopify.com/s/files/1/2531/5420/products/IMG-20230126-WA0037_b770f153-5596-41f2-bc4c-ce6237af32c3_2048x.jpg?v=1680263944',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leaf Buds Earrings',
                      style: AppTypography.kBold14,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Order at Handy Craft: August 1, 2017',
                      style: AppTypography.kExtraLight15.copyWith(
                        color: AppColors.kHintColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 9.0.h),
          const DottedLineDivider(),
          SizedBox(height: 9.h),
          const OrderReceipts(
            title: 'Price :',
            info: r'$ 56.87',
            isPrice: true,
          ),
          SizedBox(height: 5.01.h),
          const OrderReceipts(
            title: 'Quantity :',
            info: 'x2',
          ),
          SizedBox(height: 5.0.h),
          const OrderReceipts(
            title: 'Order Status :',
            info: 'Delivered',
          ),
        ],
      ),
    );
  }
}
