// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SearchModel {
  String postId;
  String imageUrl;
  SearchModel({
    required this.postId,
    required this.imageUrl,
  });

  SearchModel copyWith({
    String? postId,
    String? imageUrl,
  }) {
    return SearchModel(
      postId: postId ?? this.postId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'imageUrl': imageUrl,
    };
  }

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      postId: map['postId'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchModel.fromJson(String source) =>
      SearchModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SearchModel(postId: $postId, imageUrl: $imageUrl)';

  @override
  bool operator ==(covariant SearchModel other) {
    if (identical(this, other)) return true;

    return other.postId == postId && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => postId.hashCode ^ imageUrl.hashCode;
}
