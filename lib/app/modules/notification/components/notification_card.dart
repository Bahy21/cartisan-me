import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/notification_model.dart';
import 'package:cartisan/app/models/notification_type.dart';
import 'package:cartisan/app/modules/profile/other_store_view.dart';
import 'package:cartisan/app/modules/review/view_post_and_review_notification.dart';
import 'package:cartisan/app/modules/search/components/post_full_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({required this.notification, Key? key})
      : super(key: key);
  int get avatarSize => 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.kGrey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: InkWell(
        onTap: onTap(notification.type, notification),
        child: Row(
          children: [
            if (notification.userProfileImg.isURL)
              CircleAvatar(
                radius: (avatarSize / 2).r,
                backgroundColor: AppColors.kBackground,
                child: CachedNetworkImage(
                  imageUrl: notification.userProfileImg,
                  height: 33.h,
                  errorWidget: (context, url, dynamic error) => SizedBox(
                    height: avatarSize.h,
                    width: avatarSize.w,
                    child: ClipOval(
                      child: Material(
                        child: Transform.translate(
                          offset: Offset(-5.w, 0),
                          child: Icon(
                            Icons.person,
                            size: (avatarSize * 1.2).w,
                            color: AppColors.kPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: avatarSize.h,
                width: avatarSize.w,
                child: ClipOval(
                  child: Material(
                    child: Transform.translate(
                      offset: Offset(-5.w, 0),
                      child: Icon(
                        Icons.person,
                        size: (avatarSize * 1.2).w,
                        color: AppColors.kPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                notificationText(
                  type: notification.type,
                  username: notification.username,
                ),
                style: AppTypography.kLight14,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Function() onTap(
    NotificationType type,
    NotificationModel notification,
  ) {
    switch (type) {
      case NotificationType.comment:
        return () {
          log('comment pressed');
        };
      case NotificationType.follow:
        return () {
          Get.to<Widget>(OtherStoreView(
            userId: notification.ownerId,
          ));
        };
      case NotificationType.like:
        return () {
          if (notification.postId == null) {
            showErrorDialog('Unable fetch the post at the moment');
          } else {
            Get.to<Widget>(PostFullScreen(postId: notification.postId!));
          }
        };
      case NotificationType.order:
        return () {
          log('order pressed');
        };
      case NotificationType.message:
        return () {
          log('message pressed');
        };
      case NotificationType.review:
        return () {
          Get.to<Widget>(
            () => ViewPostAndReviewNotification(
              postId: notification.postId!,
              reviewId: notification.reviewId!,
            ),
          );
        };
      default:
        return () {
          log('exception');
        };
    }
  }
}

String notificationText({
  required NotificationType type,
  required String username,
}) {
  switch (type) {
    case NotificationType.comment:
      return '$username commented on your post';
    case NotificationType.follow:
      return '$username started following you';
    case NotificationType.like:
      return '$username liked your post';
    case NotificationType.order:
      return '$username ordered your product';
    case NotificationType.message:
      return '$username sent you a message';
    case NotificationType.review:
      return '$username reviewed your product';
    default:
      return '';
  }
}
