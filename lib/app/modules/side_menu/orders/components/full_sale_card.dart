import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/chat/components/chatroom_tile.dart';
import 'package:cartisan/app/modules/profile/other_store_view.dart';
import 'package:cartisan/app/modules/side_menu/orders/components/sale_tile.dart';
import 'package:cartisan/app/modules/side_menu/orders/full_sale_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FullSaleCard extends StatelessWidget {
  final int orderIndex;

  const FullSaleCard({
    required this.orderIndex,
    super.key,
  });
  String get currentUid => Get.find<AuthService>().currentUser!.uid;
  OrderModel get order => Get.find<SalesHistoryController>().sales[orderIndex];
  Future<Map<String, dynamic>> fetchPostAndUserData() async {
    try {
      final posts = <String, dynamic>{};
      for (final product in order.orderItems) {
        if (product.sellerId == currentUid) {
          final post = await PostAPI().getPost(product.productId);
          if (post != null) {
            posts.addAll(<String, dynamic>{product.orderItemID: post});
          }
        }
      }
      final buyer = await UserAPI().getUser(order.buyerId);
      return <String, dynamic>{
        'posts': posts,
        'buyer': buyer,
      };
    } on Exception catch (e) {
      log(e.toString());
      return <String, dynamic>{};
    }
  }

  int get _avatarSize => 45;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchPostAndUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox.shrink(),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text('Error'),
          );
        }
        final buyer = snapshot.data!['buyer'] as UserModel;
        final posts = snapshot.data!['posts'] as Map<String, dynamic>;
        return InkWell(
          onTap: () {
            Get.to<Widget>(
              () => FullSaleDetails(
                orderIndex: orderIndex,
                posts: posts,
                buyer: buyer,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 10.h,
            ),
            padding: EdgeInsets.only(
              left: 9.w,
              right: AppSpacing.eightHorizontal,
              top: AppSpacing.twelveVertical,
              bottom: AppSpacing.seventeenVertical,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.kGrey,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: _avatarSize.w,
                      width: _avatarSize.w,
                      child: buyer.url.isURL
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: buyer.url,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, dynamic error) =>
                                    ClipOval(
                                  child: Material(
                                    child: Transform.translate(
                                      offset: Offset(-8.w, 0),
                                      child: Icon(
                                        Icons.person,
                                        size: 50.w,
                                        color: AppColors.kPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : ClipOval(
                              child: Material(
                                child: Transform.translate(
                                  offset: Offset(-7.w, 0),
                                  child: Icon(
                                    Icons.person,
                                    size: 60.w,
                                    color: AppColors.kPrimary,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            buyer.username,
                            style: AppTypography.kBold14,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            buyer.country,
                            style: AppTypography.kBold14
                                .copyWith(color: AppColors.kHintColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  'Ordered by ${buyer.profileName}: ${howLongAgo(order.timestamp)}',
                  style: AppTypography.kExtraLight15.copyWith(
                    color: AppColors.kHintColor,
                    fontSize: 14.sp,
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: order.orderItems.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 5.h,
                  ),
                  itemBuilder: (context, index) => SaleTile(
                    post: (posts[order.orderItems[index].orderItemID]
                            as PostResponse)
                        .post,
                    orderItemIndex: index,
                    orderIndex: orderIndex,
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
