// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cartisan/app/models/notification_type.dart';

class NotificationModel {
  String notificationId;
  String ownerId;
  String userId;
  NotificationType type;
  int timestamp;
  String username;
  String userProfileImg;
  String? chatRoomId;
  String? postId;
  String? orderId;
  NotificationModel({
    required this.notificationId,
    required this.ownerId,
    required this.userId,
    required this.type,
    required this.timestamp,
    required this.username,
    required this.userProfileImg,
    this.chatRoomId,
    this.postId,
    this.orderId,
  });

  NotificationModel copyWith({
    String? notificationId,
    String? ownerId,
    String? userId,
    NotificationType? type,
    int? timestamp,
    String? username,
    String? userProfileImg,
    String? chatRoomId,
    String? postId,
    String? orderId,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      ownerId: ownerId ?? this.ownerId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      username: username ?? this.username,
      userProfileImg: userProfileImg ?? this.userProfileImg,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      postId: postId ?? this.postId,
      orderId: orderId ?? this.orderId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationId': notificationId,
      'ownerId': ownerId,
      'userId': userId,
      'type': type.index,
      'timestamp': timestamp,
      'username': username,
      'userProfileImg': userProfileImg,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId'] as String,
      ownerId: map['ownerId'] as String,
      userId: map['userId'] as String,
      type: NotificationType.values[map['type'] as int],
      timestamp: map['timestamp'] as int,
      username: map['username'] as String,
      userProfileImg: map['userProfileImg'] as String,
      chatRoomId: map['chatRoomId'] as String?,
      postId: map['postId'] as String?,
      orderId: map['orderId'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(notificationId: $notificationId, ownerId: $ownerId, userId: $userId, type: $type, timestamp: $timestamp, username: $username, userProfileImg: $userProfileImg , chatRoomId: $chatRoomId, postId: $postId, orderId: $orderId)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.notificationId == notificationId &&
        other.ownerId == ownerId &&
        other.userId == userId &&
        other.type == type &&
        other.timestamp == timestamp &&
        other.username == username &&
        other.userProfileImg == userProfileImg &&
        other.chatRoomId == chatRoomId &&
        other.postId == postId &&
        other.orderId == orderId;
  }

  @override
  int get hashCode {
    return notificationId.hashCode ^
        ownerId.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        timestamp.hashCode ^
        username.hashCode ^
        userProfileImg.hashCode ^
        chatRoomId.hashCode ^
        postId.hashCode ^
        orderId.hashCode;
  }
}
