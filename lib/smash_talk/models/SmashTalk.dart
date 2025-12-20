// To parse this JSON data, do
//
//     final smashTalk = smashTalkFromJson(jsonString);

import 'dart:convert';

List<SmashTalk> smashTalkFromJson(String str) => List<SmashTalk>.from(json.decode(str).map((x) => SmashTalk.fromJson(x)));

String smashTalkToJson(List<SmashTalk> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SmashTalk {
    String model;
    int pk;
    Fields fields;

    SmashTalk({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory SmashTalk.fromJson(Map<String, dynamic> json) => SmashTalk(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String content;
    int author;
    String category;
    String image;
    int views;
    DateTime createdAt;
    DateTime updatedAt;
    List<dynamic> likes;

    Fields({
        required this.title,
        required this.content,
        required this.author,
        required this.category,
        required this.image,
        required this.views,
        required this.createdAt,
        required this.updatedAt,
        required this.likes,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        content: json["content"],
        author: json["author"],
        category: json["category"],
        image: json["image"],
        views: json["views"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        likes: List<dynamic>.from(json["likes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "author": author,
        "category": category,
        "image": image,
        "views": views,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "likes": List<dynamic>.from(likes.map((x) => x)),
    };
}
