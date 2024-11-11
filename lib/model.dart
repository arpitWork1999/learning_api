// To parse this JSON data, do
//
//     final samplePosts = samplePostsFromJson(jsonString);

import 'dart:convert';

List<SamplePosts> samplePostsFromJson(String str) => List<SamplePosts>.from(
    json.decode(str).map((x) => SamplePosts.fromJson(x)));



String samplePostsToJson(List<SamplePosts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SamplePosts {
  int? userId;
  int? id;
  String? title;
  String? body;

  SamplePosts({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  SamplePosts copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) =>
      SamplePosts(
        userId: userId ?? this.userId,
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
      );

  factory SamplePosts.fromJson(Map<String, dynamic> json) => SamplePosts(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}

