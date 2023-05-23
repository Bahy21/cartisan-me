import 'package:cartisan/app/controllers/chat_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/chat_room_model.dart';
import 'package:cartisan/app/modules/chat/components/chatroom_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final chatRoomController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.kWhite,
          ),
          onPressed: () {
            Get.back<void>();
          },
        ),
        title: Text(
          'Chats',
          style: AppTypography.kMedium18.copyWith(
            color: AppColors.kWhite,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: chatRoomController.getUserChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching chats',
                style: AppTypography.kMedium18,
              ),
            );
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No chats found',
                style: AppTypography.kMedium18,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final chatRoom = snapshot.data![index];
              return ChatroomTile(
                chatRoomModel: chatRoom,
              );
            },
          );
        },
      ),
    );
  }
}
