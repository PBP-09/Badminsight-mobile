class Bookmark {
  final String id;        // <-- GANTI DARI int KE String
  final String playerId;  // <-- GANTI DARI int KE String
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
  // Ambil data player dengan aman
  var playerData = json['player']; 

  return Bookmark(
    // Pakai toString() untuk jaga-jaga
    id: json['id'].toString(),
    // Cek kalau playerData itu null
    playerId: playerData != null ? playerData['id'].toString() : "0", 
    playerName: playerData != null ? playerData['name'] : "Unknown",
    playerImage: playerData != null ? playerData['thumbnail'] : "https://via.placeholder.com/150",
    category: playerData != null ? playerData['category'] : "-",
  );
}
}