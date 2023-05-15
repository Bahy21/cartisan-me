// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  String username;
  String userId;
  String url;
  String comment;
  int timestamp;
  String commentId;

  CommentModel({
    required this.username,
    required this.userId,
    required this.url,
    required this.comment,
    required this.timestamp,
    required this.commentId,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      username: map['username'] as String,
      userId: map['userId'] as String,
      url: map['url'] as String,
      comment: map['comment'] as String,
      timestamp: map['timestamp'] as int,
      commentId: map['commentId'] as String,
    );
  }

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  CommentModel copyWith({
    String? username,
    String? userId,
    String? url,
    String? comment,
    int? timestamp,
    String? commentId,
  }) {
    return CommentModel(
      username: username ?? this.username,
      userId: userId ?? this.userId,
      url: url ?? this.url,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
      commentId: commentId ?? this.commentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'userId': userId,
      'url': url,
      'comment': comment,
      'timestamp': timestamp,
      'commentId': commentId,
    };
  }

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return 'CommentModel(username: $username, userId: $userId, url: $url, comment: $comment, timestamp: $timestamp, commentId: $commentId)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.userId == userId &&
        other.url == url &&
        other.comment == comment &&
        other.timestamp == timestamp &&
        other.commentId == commentId;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        userId.hashCode ^
        url.hashCode ^
        comment.hashCode ^
        timestamp.hashCode ^
        commentId.hashCode;
  }
}
