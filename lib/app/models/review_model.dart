class ReviewModel {
  late String reviewId;
  late String reviewText;
  late int rating;
  late String reviewerName;
  late String reviewerId;
  late int timestamp;

  ReviewModel({
    required this.reviewId,
    required this.reviewText,
    required this.rating,
    required this.reviewerName,
    required this.reviewerId,
  }) : timestamp = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'reviewID': reviewId,
      'reviewText': reviewText,
      'dateTime': timestamp,
      'rating': rating,
      'reviewerName': reviewerName,
      'reviewerID': reviewerId,
    };
  }
}