import 'package:cartisan/app/controllers/cart_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/components/cart_item_card.dart';
import 'package:cartisan/app/modules/cart/components/delete_cart_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(height: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemBuilder: (context, index) => CartItemCard(
          deleteCallback: () {
            Get.dialog<void>(DeleteCartItemDialog(
              deleteConfirmationCallback: () {},
            ));
          },
        ),
      ),
      bottomSheet: Semantics(
        button: true,
        child: InkWell(
          onTap: () {
            Get.find<CartPageController>().animateInitialPageToNext();
          },
          child: Container(
            height: 68.h,
            width: double.maxFinite,
            alignment: Alignment.center,
            color: AppColors.kPrimary,
            child: Text(
              'Proceed',
              style: AppTypography.kLight16,
            ),
          ),
        ),
      ),
    );
  }
}
