import 'package:flutter/material.dart';
import '../models/bookmark.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Bookmark> favorites;

  const FavoriteScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          "⭐ Pemain Favorit",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "Belum ada pemain favorit",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final fav = favorites[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                    title: Text(
                      "Player ID: ${fav.fields.player}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Ditambahkan pada ${fav.fields.createdAt.toLocal()}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
