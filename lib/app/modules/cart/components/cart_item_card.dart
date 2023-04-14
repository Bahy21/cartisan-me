import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/home/components/quantity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CartItemCard extends StatelessWidget {
  final VoidCallback? deleteCallback;
  final bool isOrderSummaryView;
  const CartItemCard({
    this.deleteCallback,
    this.isOrderSummaryView = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(9.h),
          decoration: BoxDecoration(
            color: AppColors.kGrey,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Container(
                height: 71.h,
                width: 71.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Special Scents',
                    style: AppTypography.kExtraLight12,
                  ),
                  Text(
                    'Scent Candle',
                    style: AppTypography.kBold14,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    r' $200.00',
                    style: AppTypography.kBold14
                        .copyWith(color: AppColors.kPrimary),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isOrderSummaryView)
                    IconButton(
                      onPressed: deleteCallback,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: SvgPicture.asset(AppAssets.kDelete),
                    )
                  else
                    const SizedBox(),
                  SizedBox(height: 30.h),
                  if (!isOrderSummaryView)
                    QuantityCard(
                      onChanged: (quantity) {},
                      isCartView: true,
                    )
                  else
                    Text(
                      'Quantity x 1',
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kHintColor),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (!isOrderSummaryView) SizedBox(height: 8.h) else const SizedBox(),
        if (!isOrderSummaryView)
          Text(
            'Delivery and shipping charges will be displayed on the checkout page.',
            style: AppTypography.kLight14,
          )
        else
          const SizedBox(),
      ],
    );
  }
}
