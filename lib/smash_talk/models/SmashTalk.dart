import 'dart:convert';

List<SmashTalk> smashTalkFromJson(String str) {
  final jsonData = json.decode(str);
  // Ambil list dari 'results'
  final list = (jsonData['results'] as List?) ?? []; 
  return list.map((x) => SmashTalk.fromJson(x)).toList();
}

class SmashTalk {
  int id;
  String title;
  String content;
  String author;
  int likeCount;
  String category;
  String? image;
  int views;
  DateTime createdAt;

  SmashTalk({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.likeCount,
    required this.category,
    this.image,
    required this.views,
    required this.createdAt,
  });

  factory SmashTalk.fromJson(Map<String, dynamic> json) {
    return SmashTalk(
      id: json["id"] ?? 0,
      title: json["title"] ?? "Tanpa Judul",
      content: json["content"] ?? "",
      // Pastikan di views.py Django kamu mengirim 'author': p.author.username
      author: json["author"] ?? "Anonymous", 
      likeCount: json["like_count"] ?? 0,
      category: json["category"] ?? "Umum",
      image: json["image"],
      views: json["views"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
    );
  }
}