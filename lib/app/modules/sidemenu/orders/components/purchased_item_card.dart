import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/controllers/purchase_history_controller.dart';
import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/data/constants/app_spacing.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/review/create_review.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/cancel_and_refund_button.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/change_order_status_button.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PurchasedItemCard extends StatefulWidget {
  final int orderIndex;
  final int orderItemIndex;
  final PostModel product;
  final UserModel seller;
  const PurchasedItemCard({
    required this.orderItemIndex,
    required this.orderIndex,
    required this.product,
    required this.seller,
    Key? key,
  }) : super(key: key);

  @override
  _PurchasedItemCardState createState() => _PurchasedItemCardState();
}

class _PurchasedItemCardState extends State<PurchasedItemCard> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final order =
          Get.find<PurchaseHistoryController>().purchases[widget.orderIndex];
      final orderItem = order.orderItems[widget.orderItemIndex];

      final cancelable =
          orderItem.status == OrderItemStatus.awaitingFulfillment;
      final showStatus = ![
        OrderItemStatus.pending,
        OrderItemStatus.awaitingPayment,
      ].contains(orderItem.status);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: widget.product.images.first,
                width: 50.w,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                errorWidget: (
                  context,
                  url,
                  dynamic error,
                ) =>
                    const Icon(Icons.error),
              ),
            ),
            SizedBox(
              width: AppSpacing.eightHorizontal,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.productName,
                  style: AppTypography.kBold14,
                ),
                Text(
                  'From: ${widget.seller.profileName}',
                  style: AppTypography.kExtraLight12,
                ),
              ],
            ),
            Spacer(),
            if (showStatus)
              ChangeOrderStatusButton(
                orderIndex: widget.orderIndex,
                orderItemIndex: widget.orderItemIndex,
              ),
          ]),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price'),
                    Text('\$${widget.product.price.toStringAsFixed(2)}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantity'),
                    Text('x${orderItem.quantity}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Service Fee'),
                    Text(
                        '\$${(orderItem.serviceFeeInCents / 100).toPrecision(2).toStringAsFixed(2)}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Cost'),
                    Text(
                        '\$${(orderItem.deliveryCostInCents / 100).toPrecision(2).toStringAsFixed(2)}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tax Amount'),
                    Text('\$${orderItem.tax.toStringAsFixed(2)}'),
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total'),
                    Text('\$${orderItem.grossTotal.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),
          if (cancelable)
            CancelAndRefundButton(
              orderIndex: widget.orderIndex,
              orderItemIndex: widget.orderItemIndex,
            ),
          if (orderItem.status == OrderItemStatus.completed) ...[
            SizedBox(
              height: AppSpacing.eightVertical,
            ),
            PrimaryButton(
              onTap: () {
                Get.bottomSheet<Widget>(
                  CreateReview(
                    orderId: order.orderId,
                    orderItem: orderItem,
                    post: widget.product,
                  ),
                );
              },
              text: 'Leave a review',
            ),
          ],
          SizedBox(
            height: 5.h,
          ),
          const Divider(
            color: Colors.white,
          ),
        ],
      );
    });
  }
}
