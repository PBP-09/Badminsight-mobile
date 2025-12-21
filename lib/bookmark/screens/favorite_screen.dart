import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/bookmark.dart';
import 'package:badminsights_mobile/left_drawer.dart'; 

class FavoriteScreen extends StatefulWidget {
  // Hapus parameter required favorites
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  
  // Fungsi Fetch Data dari Django
  Future<List<Bookmark>> fetchBookmarks(CookieRequest request) async {
    // Sesuaikan URL ini dengan endpoint API Bookmark temanmu
    // Contoh: http://127.0.0.1:8000/bookmark/json/
    final response = await request.get('http://127.0.0.1:8000/bookmark/json/'); 
    
    // Parsing JSON (sesuaikan dengan struktur JSON bookmark)
    List<Bookmark> listBookmark = [];
    for (var d in response) {
      if (d != null) {
        listBookmark.add(Bookmark.fromJson(d));
      }
    }
    return listBookmark;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      drawer: const LeftDrawer(), 
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
      // Pake FutureBuilder biar datanya dinamis
      body: FutureBuilder(
        future: fetchBookmarks(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada pemain favorit yang ditambahkan.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          } 
          
          // Kalau ada data
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final Bookmark fav = snapshot.data![index];
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
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      // Pastikan model Bookmark punya field playerImage atau sejenisnya
                      // Kalau URL localhost, replace dulu
                      fav.playerImage.replaceAll("10.0.2.2", "127.0.0.1"), 
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    fav.playerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      fav.category,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}