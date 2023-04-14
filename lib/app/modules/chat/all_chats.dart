import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/chat_model.dart';
import 'package:cartisan/app/modules/chat/components/all_chat_card.dart';
import 'package:cartisan/app/modules/chat/conversation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllChats extends StatelessWidget {
  const AllChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back<void>();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        title: Text('All Chats', style: AppTypography.kLight15),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 19.w),
        physics: const BouncingScrollPhysics(),
        itemCount: chatList.length,
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          return AllChatCard(
            onTap: () {
              Get.to<Widget>(() => ConversationView(
                    chat: chatList[index],
                  ));
            },
            chat: chatList[index],
          );
        },
      ),
    );
  }
}
