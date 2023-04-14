import 'package:cartisan/app/controllers/cart_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/components/billing_address_drop_down.dart';
import 'package:cartisan/app/modules/cart/components/custom_payment_field.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final _cardNumberController = TextEditingController();
  final _dateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _zipController = TextEditingController();
  bool saveDetails = false;

  @override
  Widget build(BuildContext context) {
    final borderWith = 0.5.w;
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(AppAssets.kCancel),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
              child: Text(
                'Add your payment information',
                style: AppTypography.kMedium16.copyWith(color: AppColors.kGrey),
              ),
            ),
            SizedBox(height: 14.h),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
              child: Text(
                'Card Information',
                style: AppTypography.kMedium12
                    .copyWith(color: AppColors.kHintColor),
              ),
            ),
            SizedBox(height: AppSpacing.eightVertical),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
                  border:
                      Border.all(color: AppColors.kGrey2, width: borderWith),
                ),
                child: Column(
                  children: [
                    CustomPaymentField(
                      hintText: 'Card Number',
                      controller: _cardNumberController,
                    ),
                    Divider(
                      height: 0.h,
                      color: AppColors.kGrey2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomPaymentField(
                            hintText: 'MM/YY',
                            controller: _dateController,
                          ),
                        ),
                        Container(
                          height: 60.h,
                          width: borderWith,
                          color: AppColors.kGrey2,
                        ),
                        Expanded(
                          child: CustomPaymentField(
                            hintText: 'CVV',
                            controller: _cvvController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
              child: Text(
                'Billing Address',
                style: AppTypography.kMedium12
                    .copyWith(color: AppColors.kHintColor, fontSize: 12.sp),
              ),
            ),
            SizedBox(height: AppSpacing.eightVertical),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
                  border:
                      Border.all(color: AppColors.kGrey2, width: borderWith),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BillingAddressDropDown(
                      items: const ['United States', 'Canada', 'Mexico'],
                      onChanged: (value) {},
                    ),
                    Divider(
                      height: 0.0.h,
                      color: AppColors.kGrey2,
                    ),
                    CustomPaymentField(
                      hintText: 'Zip COde',
                      controller: _zipController,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                children: [
                  Checkbox(
                    value: saveDetails,
                    activeColor: AppColors.kPrimary,
                    side:
                        BorderSide(color: AppColors.kGrey2, width: borderWith),
                    onChanged: (value) {
                      setState(() {
                        saveDetails = value!;
                      });
                    },
                  ),
                  Text(
                    'Save for future Cartisan Exchange payments',
                    style: AppTypography.kLight12
                        .copyWith(color: AppColors.kGrey2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 41.h),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
              child: ElevatedButton(
                onPressed: () {
                  Get.find<CartPageController>().animateInitialPageToNext();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
                  ),
                  fixedSize: Size(Get.width, 50.h),
                ),
                child: Text(
                  r'Pay \$ 1,000.00',
                  style:
                      AppTypography.kMedium16.copyWith(color: AppColors.kWhite),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.twentyVertical),
          ],
        ),
      ),
    );
  }
}
