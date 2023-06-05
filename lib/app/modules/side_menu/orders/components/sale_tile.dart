import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/side_menu/orders/components/dotted_line_divider.dart';
import 'package:cartisan/app/modules/side_menu/orders/components/order_receipts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SaleTile extends StatelessWidget {
  final int orderItemIndex;
  final PostModel post;
  final int orderIndex;
  const SaleTile({
    required this.orderItemIndex,
    required this.orderIndex,
    required this.post,
    super.key,
  });
  SalesHistoryController get sc => Get.find<SalesHistoryController>();
  OrderItemModel get orderItem =>
      sc.sales[orderIndex].orderItems[orderItemIndex];
  String get orderId => sc.sales[orderIndex].orderId;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
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
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        post.images.first,
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
                        post.productName,
                        style: AppTypography.kBold14,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        post.description,
                        style: AppTypography.kBold14,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 9.0.h),
            const DottedLineDivider(),
            SizedBox(height: 9.h),
            OrderReceipts(
              title: 'Price :',
              info: '\$${orderItem.grossTotal} ',
              isPrice: true,
            ),
            SizedBox(
              height: 5.01.h,
            ),
            OrderReceipts(
              title: 'Quantity:',
              info: 'x${orderItem.quantity}',
            ),
            SizedBox(
              height: 5.0.h,
            ),
            OrderReceipts(
              title: 'Order Status :',
              info: orderItemStatusToString(orderItem.status),
            ),
          ],
        ),
      ),
    );
  }
}
