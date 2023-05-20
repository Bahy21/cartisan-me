import 'dart:developer';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/chat_room_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  static const int _messageLimit = 30;
  static const int _chatRoomLimit = 10;
  final db = Database();
  String get _currentUid => Get.find<AuthService>().currentUser!.uid;
  UserModel get _currentUserModel => Get.find<UserController>().currentUser!;
  Stream<List<ChatMessage>> currentChatMessages(String chatRoomId) {
    return db
        .chatRoomMessages(chatRoomId)
        .orderBy('createdAt', descending: true)
        .limit(_messageLimit)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (doc) => ChatMessage.fromJson(doc.data()),
              )
              .toList(),
        );
  }

  Stream<List<ChatRoomModel>> getUserChats() {
    return db.chatRoomsCollection
        .where('participants', arrayContains: _currentUid)
        .orderBy('lastUpdated', descending: true)
        .limit(_chatRoomLimit)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (doc) => ChatRoomModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Future<ChatRoomModel?> createChatroom({
    required String otherParticipant,
    required String otherParticipantName,
    required String? otherParticipantPictureUrl,
  }) async {
    try {
      final chatRoomId = createChatID(_currentUid, otherParticipant);
      final newChat = ChatRoomModel(
        chatRoomId: chatRoomId,
        participants: [_currentUid, otherParticipant],
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
        participantDetails: <String, dynamic>{
          _currentUid: <String, dynamic>{
            'name': _currentUserModel.username,
            'profilePicture': _currentUserModel.url,
          },
          otherParticipant: <String, dynamic>{
            'name': otherParticipantName,
            'profilePicture': otherParticipantPictureUrl,
          },
        },
        unreadMessages: 0,
        latestMessage: '',
      );
      final payload = newChat.toMap();
      payload.addAll(<String, dynamic>{'createdBy': _currentUid});
      await db.chatRoomsCollection.doc(chatRoomId).set(
            payload,
          );
      return newChat;
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<ChatRoomModel?> chatExists(String otherParticipantId) async {
    try {
      final chatId = createChatID(_currentUid, otherParticipantId);
      final chatRoom = await db.chatRoomsCollection.doc(chatId).get();
      if (chatRoom.exists) {
        return ChatRoomModel.fromMap(
          chatRoom.data() as Map<String, dynamic>,
        );
      }
      return null;
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required ChatMessage newMessage,
  }) async {
    try {
      await db.chatRoomsCollection.doc(chatRoomId).update(
        {
          'latestMessage': newMessage.text,
          'lastUpdated': DateTime.now().millisecondsSinceEpoch,
          'unreadMessages': FieldValue.increment(1),
        },
      );

      newMessage.customProperties = <String, dynamic>{};
      await db.chatRoomMessages(chatRoomId).add(
            newMessage.toJson(),
          );
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  void readMessages(String chatRoomId) async {
    try {
      await db.chatRoomsCollection.doc(chatRoomId).update(
        {
          'unreadMessages': 0,
        },
      );
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  String createChatID(String a, String b) {
    if (a.compareTo(b) > 0) {
      return '${b}_$a';
    } else {
      return '${a}_$b';
    }
  }
}
