// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessage chat;
  const ChatBubble({
    required this.chat,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final message = widget.chat.messageContent;
    return widget.chat.messageType == 'sender'
        ? Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.twentyFourHorizontal,
                vertical: AppSpacing.seventeenVertical,
              ),
              constraints: BoxConstraints(maxWidth: 315.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.twentyRadius),
                  bottomLeft: Radius.circular(AppSpacing.twentyRadius),
                  topRight: Radius.circular(AppSpacing.twentyRadius),
                ),
                color: AppColors.kPrimary,
              ),
              child: Text(
                message,
                style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
              ),
            ),
          )
        : Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.twentyFourHorizontal,
                vertical: AppSpacing.seventeenVertical,
              ),
              constraints: BoxConstraints(maxWidth: 315.0.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.twentyRadius),
                  topRight: Radius.circular(AppSpacing.twentyRadius),
                  bottomRight: Radius.circular(AppSpacing.twentyRadius),
                ),
                color: AppColors.kGrey,
              ),
              child: Text(
                message,
                style: AppTypography.kLight14
                    .copyWith(color: AppColors.kWhite, fontSize: 14.sp),
              ),
            ),
          );
  }
}
