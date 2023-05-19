// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReportModel {
  String reportId;
  String reportedUsersId;
  String flaggedBy;
  String reportedFor;
  bool isGroup;
  String postId;
  String messageId;

  ReportModel({
    required this.reportId,
    required this.reportedUsersId,
    required this.flaggedBy,
    required this.reportedFor,
    required this.isGroup,
    required this.postId,
    required this.messageId,
  });

  ReportModel copyWith({
    String? reportId,
    String? reportedUsersId,
    String? flaggedBy,
    String? reportedFor,
    bool? isGroup,
    String? postId,
    String? messageId,
  }) {
    return ReportModel(
      reportId: reportId ?? this.reportId,
      reportedUsersId: reportedUsersId ?? this.reportedUsersId,
      flaggedBy: flaggedBy ?? this.flaggedBy,
      reportedFor: reportedFor ?? this.reportedFor,
      isGroup: isGroup ?? this.isGroup,
      postId: postId ?? this.postId,
      messageId: messageId ?? this.messageId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reportId': reportId,
      'reportedUsersId': reportedUsersId,
      'flaggedBy': flaggedBy,
      'reportedFor': reportedFor,
      'isGroup': isGroup,
      'postId': postId,
      'messageId': messageId,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      reportId: map['reportId'] as String,
      reportedUsersId: map['reportedUsersId'] as String,
      flaggedBy: map['flaggedBy'] as String,
      reportedFor: map['reportedFor'] as String,
      isGroup: map['isGroup'] as bool,
      postId: map['postId'] as String,
      messageId: map['messageId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) =>
      ReportModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReportModel(reportId: $reportId, reportedUsersId: $reportedUsersId, flaggedBy: $flaggedBy, reportedFor: $reportedFor, isGroup: $isGroup, postId: $postId, messageId: $messageId)';
  }

  @override
  bool operator ==(covariant ReportModel other) {
    if (identical(this, other)) return true;

    return other.reportId == reportId &&
        other.reportedUsersId == reportedUsersId &&
        other.flaggedBy == flaggedBy &&
        other.reportedFor == reportedFor &&
        other.isGroup == isGroup &&
        other.postId == postId &&
        other.messageId == messageId;
  }

  @override
  int get hashCode {
    return reportId.hashCode ^
        reportedUsersId.hashCode ^
        flaggedBy.hashCode ^
        reportedFor.hashCode ^
        isGroup.hashCode ^
        postId.hashCode ^
        messageId.hashCode;
  }
}
