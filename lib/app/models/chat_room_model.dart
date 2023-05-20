import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatRoomModel {
  String chatRoomId;
  List<String> participants;
  int lastUpdated;
  Map<String, dynamic> participantDetails;
  String latestMessage;
  int unreadMessages;
  ChatRoomModel({
    required this.chatRoomId,
    required this.participants,
    required this.lastUpdated,
    required this.participantDetails,
    required this.latestMessage,
    required this.unreadMessages,
  });

  ChatRoomModel copyWith({
    String? chatRoomId,
    List<String>? participants,
    int? lastUpdated,
    Map<String, dynamic>? participantDetails,
    String? latestMessage,
    int? unreadMessages,
  }) {
    return ChatRoomModel(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      participants: participants ?? this.participants,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      participantDetails: participantDetails ?? this.participantDetails,
      latestMessage: latestMessage ?? this.latestMessage,
      unreadMessages: unreadMessages ?? this.unreadMessages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatRoomId': chatRoomId,
      'participants': participants,
      'lastUpdated': lastUpdated,
      'participantDetails': participantDetails,
      'latestMessage': latestMessage,
      'unreadMessages': unreadMessages,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      chatRoomId: map['chatRoomId'] as String,
      participants: (map['participants'] as List).cast<String>(),
      lastUpdated: map['lastUpdated'] as int,
      participantDetails: Map<String, dynamic>.from(
          map['participantDetails'] as Map<String, dynamic>),
      latestMessage: map['latestMessage'] as String,
      unreadMessages: map['unreadMessages'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) =>
      ChatRoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatRoomModel(chatRoomId: $chatRoomId, participants: $participants, lastUpdated: $lastUpdated, participantDetails: $participantDetails, latestMessage: $latestMessage, unreadMessages: $unreadMessages)';
  }

  @override
  bool operator ==(covariant ChatRoomModel other) {
    if (identical(this, other)) return true;

    return other.chatRoomId == chatRoomId &&
        listEquals(other.participants, participants) &&
        other.lastUpdated == lastUpdated &&
        mapEquals<String, dynamic>(
            other.participantDetails, participantDetails) &&
        other.latestMessage == latestMessage &&
        other.unreadMessages == unreadMessages;
  }

  @override
  int get hashCode {
    return chatRoomId.hashCode ^
        participants.hashCode ^
        lastUpdated.hashCode ^
        participantDetails.hashCode ^
        latestMessage.hashCode ^
        unreadMessages.hashCode;
  }
}
