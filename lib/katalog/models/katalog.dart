import 'dart:convert';

List<Katalog> katalogFromJson(String str) =>
    List<Katalog>.from(json.decode(str).map((x) => Katalog.fromJson(x)));

class Katalog {
  final int id;
  final String name;
  final String category;
  final int price;
  final int stock;
  final String description;
  final String imageUrl;
  final double rating;

  Katalog({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.description,
    required this.imageUrl,
    required this.rating,
  });

  factory Katalog.fromJson(Map<String, dynamic> json) => Katalog(
        id: json['id'],
        name: json['name'] ?? '',
        category: json['category'] ?? '',
        price: json['price'] ?? 0,
        stock: json['stock'] ?? 0,
        description: json['description'] ?? '',
        imageUrl: json['image_url'] ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      );
}
