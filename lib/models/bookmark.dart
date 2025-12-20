// To parse this JSON data, do
//
//     final bookmark = bookmarkFromJson(jsonString);

import 'dart:convert';

List<Bookmark> bookmarkFromJson(String str) => List<Bookmark>.from(json.decode(str).map((x) => Bookmark.fromJson(x)));

String bookmarkToJson(List<Bookmark> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bookmark {
    String model;
    int pk;
    Fields fields;

    Bookmark({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
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
    int user;
    String player;
    DateTime createdAt;

    Fields({
        required this.user,
        required this.player,
        required this.createdAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        player: json["player"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "player": player,
        "created_at": createdAt.toIso8601String(),
    };
}