// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReviewModel {
  String reviewId;
  String reviewText;
  double rating;
  String reviewerName;
  String reviewerId;
  int timestamp;

  ReviewModel({
    required this.reviewId,
    required this.reviewText,
    required this.rating,
    required this.reviewerName,
    required this.reviewerId,
    required this.timestamp,
  });
  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewId: map['reviewId'] as String,
      reviewText: map['reviewText'] as String,
      rating: (map['rating'] as num).toDouble(),
      reviewerName: map['reviewerName'] as String,
      reviewerId: map['reviewerId'] as String,
      timestamp: map['timestamp'] as int,
    );
  }

  @override
  int get hashCode {
    return reviewId.hashCode ^
        reviewText.hashCode ^
        rating.hashCode ^
        reviewerName.hashCode ^
        reviewerId.hashCode ^
        timestamp.hashCode;
  }

  @override
  String toString() {
    return 'ReviewModel(reviewId: $reviewId, reviewText: $reviewText, rating: $rating, reviewerName: $reviewerName, reviewerId: $reviewerId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant ReviewModel other) {
    if (identical(this, other)) return true;

    return other.reviewId == reviewId &&
        other.reviewText == reviewText &&
        other.rating == rating &&
        other.reviewerName == reviewerName &&
        other.reviewerId == reviewerId &&
        other.timestamp == timestamp;
  }

  ReviewModel copyWith({
    String? reviewId,
    String? reviewText,
    double? rating,
    String? reviewerName,
    String? reviewerId,
    int? timestamp,
  }) {
    return ReviewModel(
      reviewId: reviewId ?? this.reviewId,
      reviewText: reviewText ?? this.reviewText,
      rating: rating ?? this.rating,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewerId: reviewerId ?? this.reviewerId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reviewId': reviewId,
      'reviewText': reviewText,
      'rating': rating,
      'reviewerName': reviewerName,
      'reviewerId': reviewerId,
      'timestamp': timestamp,
    };
  }

  String toJson() => json.encode(toMap());
}
