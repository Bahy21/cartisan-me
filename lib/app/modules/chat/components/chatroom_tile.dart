import 'dart:developer';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/models/chat_room_model.dart';
import 'package:cartisan/app/modules/chat/basic_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatroomTile extends StatelessWidget {
  final ChatRoomModel chatRoomModel;
  const ChatroomTile({required this.chatRoomModel, super.key});
  String get currentUid => Get.find<AuthService>().currentUser!.uid;
  int get _avatarSize => 50;
  @override
  Widget build(BuildContext context) {
    final otherParticipant = chatRoomModel.participants
        .firstWhere((element) => element != currentUid);
    final otherParticipantDetails = chatRoomModel
        .participantDetails[otherParticipant] as Map<String, dynamic>;
    final otherParticipantName = otherParticipantDetails['name'] as String;
    final otherParticipantAvatar =
        otherParticipantDetails['profilePicture'] as String?;
    return ListTile(
      onTap: () {
        Get.to<Widget>(BasicChat(
          chatRoomModel: chatRoomModel,
          otherParticipantName: otherParticipantName,
          otherParticipantAvatarURL: otherParticipantAvatar,
        ));
      },
      leading: otherParticipantAvatar?.isURL ?? false
          ? CircleAvatar(
              radius: (_avatarSize / 2).w,
              backgroundImage: NetworkImage(otherParticipantAvatar!),
            )
          : SizedBox(
              width: _avatarSize.w,
              height: _avatarSize.w,
              child: ClipOval(
                child: Material(
                  child: Transform.translate(
                    offset: Offset(-5.w, 0),
                    child: Icon(
                      Icons.person,
                      size: (_avatarSize * 1.2).w,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
            ),
      title: Text(otherParticipantName),
      subtitle: Text(chatRoomModel.latestMessage),
      trailing: Text(howLongAgo(chatRoomModel.lastUpdated)),
    );
  }
}

String howLongAgo(int timestamp) {
  final difference =
      DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
  if (difference.inDays > 0) {
    return '${difference.inDays} days ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} mins ago';
  } else {
    return '${difference.inSeconds}s ago';
  }
}
