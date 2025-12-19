class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final int likeCount;
  final String category;
  final String? image;
  final int views;

  Post({
    required this.id, required this.title, required this.content,
    required this.author, required this.likeCount, required this.category,
    this.image, required this.views,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    author: json["author"],
    likeCount: json["like_count"],
    category: json["category"],
    image: json["image"],
    views: json["views"],
  );
}