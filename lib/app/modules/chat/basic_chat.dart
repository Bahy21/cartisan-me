import 'dart:developer';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/chat_controller.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/chat_room_model.dart';
import 'package:cartisan/app/modules/chat/components/data.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';

class BasicChat extends StatefulWidget {
  final ChatRoomModel chatRoomModel;
  final String otherParticipantName;
  final String? otherParticipantAvatarURL;
  const BasicChat({
    required this.chatRoomModel,
    required this.otherParticipantName,
    required this.otherParticipantAvatarURL,
    super.key,
  });

  @override
  _BasicChatState createState() => _BasicChatState();
}

class _BasicChatState extends State<BasicChat> {
  final cc = Get.find<ChatController>();
  List<ChatMessage> messages = basicSample;
  final _avatarSize = 50;
  final _currentUid = Get.find<AuthService>().currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: (_avatarSize + 10).w,
        leading: widget.otherParticipantAvatarURL?.isURL ?? false
            ? Padding(
                padding: EdgeInsets.only(left: 10.0.w),
                child: CircleAvatar(
                  radius: (_avatarSize / 2).w,
                  backgroundImage:
                      NetworkImage(widget.otherParticipantAvatarURL!),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 10.0.w),
                child: SizedBox(
                  width: _avatarSize.w,
                  height: _avatarSize.w,
                  child: ClipOval(
                    child: Material(
                      child: Transform.translate(
                        offset: Offset(-6.w, 0),
                        child: Icon(
                          Icons.person,
                          color: AppColors.kPrimary,
                          size: (_avatarSize * 1.3).w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        title: Text(
          widget.otherParticipantName,
          style: AppTypography.kLight14,
        ),
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: cc.currentChatMessages(widget.chatRoomModel.chatRoomId),
        builder: (context, snapshot) {
          messages = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DashChat(
              inputOptions: InputOptions(
                inputDecoration: InputDecoration(
                  fillColor: AppColors.kFilledColor,
                  filled: true,
                  hintText: 'Type a message...',
                ),
                sendButtonBuilder: (onSend) {
                  return IconButton(
                    onPressed: onSend,
                    icon: const Icon(Icons.send),
                  );
                },
              ),
              currentUser: ChatUser(
                id: _currentUid,
                // ignore: avoid_dynamic_calls
                firstName: widget.chatRoomModel.participantDetails[
                    Get.find<AuthService>().currentUser!.uid]['name'] as String,
                profileImage: Get.find<UserController>().currentUser?.url,
                customProperties: <String, dynamic>{},
              ),
              onSend: (messsage) {
                cc.sendMessage(
                  chatRoomId: widget.chatRoomModel.chatRoomId,
                  newMessage: messsage,
                );
              },
              messages: messages,
            ),
          );
        },
      ),
    );
  }
}
