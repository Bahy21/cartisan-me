import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/update_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeOrderStatusButton extends StatefulWidget {
  final OrderModel order;
  final OrderItemModel orderItem;
  const ChangeOrderStatusButton({
    required this.order,
    required this.orderItem,
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeOrderStatusButton> createState() =>
      _ChangeOrderStatusButtonState();
}

class _ChangeOrderStatusButtonState extends State<ChangeOrderStatusButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.bottomSheet<Widget>(
          UpdateStatusCard(
            orderItem: widget.orderItem,
            orderId: widget.order.orderId,
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
          widget.orderItem.status.name,
          style: AppTypography.kBold12,
        ),
      ),
    );
  }
}
