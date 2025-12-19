class Bookmark {
  final int id;
  final int playerId;
  final String playerName;
  final String playerImage;
  final String category;

  Bookmark({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.playerImage,
    required this.category,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      playerId: json['player']['id'],
      playerName: json['player']['name'],
      playerImage: json['player']['thumbnail'],
      category: json['player']['category'],
    );
  }
}
