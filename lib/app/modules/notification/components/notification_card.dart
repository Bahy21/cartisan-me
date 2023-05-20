import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/notification_model.dart';
import 'package:cartisan/app/models/notification_type.dart';
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
      child: Row(
        children: [
          if (notification.userProfileImg.isURL)
            CircleAvatar(
              radius: (avatarSize / 2).r,
              backgroundColor: AppColors.kBackground,
              child: Image.network(
                notification.userProfileImg,
                height: 33.h,
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
    );
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
    case NotificationType.messsage:
      return '$username sent you a message';
    default:
      return '';
  }
}
