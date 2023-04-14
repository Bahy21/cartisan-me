import 'package:cartisan/app/controllers/cart_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/address_view.dart';
import 'package:cartisan/app/modules/cart/cart_view.dart';
import 'package:cartisan/app/modules/cart/components/custom_cart_appbar.dart';
import 'package:cartisan/app/modules/cart/components/custom_stepper.dart';
import 'package:cartisan/app/modules/cart/components/payment_view.dart';
import 'package:cartisan/app/modules/cart/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CartViewPages extends GetView<CartPageController> {
  List<Widget> pages = [
    const CartView(),
    const AddressView(),
    const PaymentView(),
    const OrderSummary(),
  ];
  List<String> pagesName = [
    'Cart',
    'Shipping',
    'Payment',
    'Success',
  ];

  CartViewPages({super.key});
  @override
  Widget build(BuildContext context) {
    return GetX<CartPageController>(
      init: CartPageController(),
      builder: (statusController) {
        return WillPopScope(
          onWillPop: () async {
            if (statusController.initialPageIndex == 0) {
              await Get.delete<CartPageController>();
              Get.back<void>();
            } else {
              statusController.updateStatus(
                index: statusController.initialPageIndex,
                status: false,
              );

              await statusController.animateInitialPageToPrevious();
            }
            return false;
          },
          child: Scaffold(
            appBar: (statusController.initialPageIndex == 0)
                ? CustomCartAppbar(
                    chatCallback: () {},
                    leadingCallback: () {
                      Get
                        ..delete<CartPageController>()
                        ..back<void>();
                    },
                  )
                : (statusController.initialPageIndex == 1)
                    ? AddressAppBar(
                        leadingCallback: () {
                          statusController
                            ..updateStatus(
                              index: statusController.initialPageIndex,
                              status: false,
                            )
                            ..animateInitialPageToPrevious();
                        },
                        changeAddressCallback: () {},
                      )
                    : (statusController.initialPageIndex == 2)
                        ? PaymentAppBar(
                            leadingCallback: () {
                              statusController
                                ..updateStatus(
                                  index: statusController.initialPageIndex,
                                  status: false,
                                )
                                ..animateInitialPageToPrevious();
                            },
                          )
                        : AppBar(),
            body: Column(
              children: [
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child:
                      CustomStepper(statuses: statusController.statusesValue),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Row(
                    children: [
                      SizedBox(width: 30.w),
                      Text(
                        pagesName[0],
                        style: AppTypography.kExtraLight12,
                      ),
                      SizedBox(width: 58.w),
                      Text(
                        pagesName[1],
                        style: AppTypography.kExtraLight12,
                      ),
                      SizedBox(width: 43.w),
                      Text(
                        pagesName[2],
                        style: AppTypography.kExtraLight12,
                      ),
                      SizedBox(width: 46.w),
                      Text(
                        pagesName[3],
                        style: AppTypography.kExtraLight12,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                Expanded(
                  child: PageView.builder(
                    controller: statusController.initialScreenController,
                    itemBuilder: (context, index) {
                      return pages[index];
                    },
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      statusController.updateStatus(
                        index: index,
                        status: true,
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
