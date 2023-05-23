// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';

class PostResponse {
  UserModel owner;
  PostModel post;
  PostResponse({
    required this.owner,
    required this.post,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'owner': owner.toMap(),
      'post': post.toMap(),
    };
  }

  factory PostResponse.fromMap(Map<String, dynamic> map) {
    return PostResponse(
      owner: UserModel.fromMap(
          (map['user'] ?? map['owner']) as Map<String, dynamic>),
      post: PostModel.fromMap(map['post'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostResponse.fromJson(String source) =>
      PostResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
