class News {
  final int id;
  final String title;
  final String content;
  final String authorUsername;
  final DateTime datePublished;
  final String category;
  final String? imageUrl;
  final int views;
  final int totalUpvotes;
  final bool isUpvoted;
  final bool isRead;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.authorUsername,
    required this.datePublished,
    required this.category,
    this.imageUrl,
    required this.views,
    required this.totalUpvotes,
    required this.isUpvoted,
    required this.isRead,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      authorUsername: json['author_username'],
      datePublished: DateTime.parse(json['date_published']),
      category: json['category'],
      imageUrl: json['image'],
      views: json['views'],
      totalUpvotes: json['total_upvotes'],
      isUpvoted: json['is_upvoted'] ?? false,
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author_username': authorUsername,
      'date_published': datePublished.toIso8601String(),
      'category': category,
      'image': imageUrl,
      'views': views,
      'total_upvotes': totalUpvotes,
      'is_upvoted': isUpvoted,
      'is_read': isRead,
    };
  }
}