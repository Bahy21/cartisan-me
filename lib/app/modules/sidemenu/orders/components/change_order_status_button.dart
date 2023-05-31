import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/update_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeOrderStatusButton extends StatefulWidget {
  final int orderIndex;
  final int orderItemIndex;
  const ChangeOrderStatusButton({
    required this.orderIndex,
    required this.orderItemIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeOrderStatusButton> createState() =>
      _ChangeOrderStatusButtonState();
}

class _ChangeOrderStatusButtonState extends State<ChangeOrderStatusButton> {
  OrderItemModel get orderItem => Get.find<SalesHistoryController>()
      .sales[widget.orderIndex]
      .orderItems[widget.orderItemIndex];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.bottomSheet<Widget>(
          UpdateStatusCard(
            orderItemIndex: widget.orderItemIndex,
            orderIndex: widget.orderIndex,
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.kPrimary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          orderItemStatusToString(orderItem.status),
          style: AppTypography.kBold12,
        ),
      ),
    );
  }
}
