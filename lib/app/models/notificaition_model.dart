import 'notification_types.dart'

class NotificationModel {
  String notificationId;
  String ownerId;
  String userId;
  NotificationType type;
  int timestamp;
  String username;
  String userProfileImg;
  
  NotificationModel({
    required this.notificationId,
    required this.ownerId,
    required this.userId,
    required this.timestamp,
    required this.username,
    required this.type,
    required this.userProfileImg,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'userId': userId,
      'timestamp': timestamp,
      'username': username,
      'type': type,
      'userProfileImg': userProfileImg,
    };
  }
}