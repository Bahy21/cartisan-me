import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/chat_model.dart';
import 'package:cartisan/app/modules/chat/components/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ConversationView extends StatelessWidget {
  final ChatModel chat;
  const ConversationView({
    required this.chat,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(chat.name, style: AppTypography.kLight15),
        actions: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: chat.imageURL == null ? AppColors.kPrimary : null,
            child: chat.imageURL == null
                ? Text(
                    chat.name[0],
                    style: AppTypography.kMedium18
                        .copyWith(color: AppColors.kWhite),
                  )
                : Hero(
                    tag: chat.name,
                    child: ClipOval(child: Image.network(chat.imageURL!)),
                  ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.only(
          left: AppSpacing.twentyHorizontal,
          right: AppSpacing.twentyHorizontal,
          bottom: 100.h,
        ),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ChatBubble(
            chat: messages[index],
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemCount: messages.length,
        reverse: true,
      ),
      bottomSheet: Container(
        color: AppColors.kBackground,
        padding: EdgeInsets.all(20.h),
        child: TextField(
          controller: TextEditingController(),
          decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(AppAssets.kPlusCircle),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide.none,
            ),
            hintText: 'Send a message',
          ),
        ),
      ),
    );
  }
}
