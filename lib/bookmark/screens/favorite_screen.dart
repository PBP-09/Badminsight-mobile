import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/bookmark.dart';
import 'package:badminsights_mobile/left_drawer.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  // Fetch bookmark hanya untuk USER LOGIN
  Future<List<Bookmark>> fetchBookmarks(CookieRequest request) async {
    // kalau belum login, langsung kosongin
    if (!request.loggedIn) {
      return [];
    }

    // endpoint bookmark milik user
    final response = await request.get(
      "https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/bookmark/favorites/json/",
    );

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

      // JIKA BELUM LOGIN
      body: !request.loggedIn
          ? const Center(
              child: Text(
                "Silakan login untuk melihat bookmark.",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : FutureBuilder(
              future: fetchBookmarks(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada pemain favorit yang ditambahkan.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final Bookmark fav = snapshot.data![index];
                    return Container(
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8),
                          child: Image.network(
                            fav.playerImage.replaceAll(
                                "10.0.2.2", "127.0.0.1"),
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (ctx, err, stack) =>
                                    const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        title: Text(
                          fav.playerName,
                          style: const TextStyle(
                              fontWeight:
                                  FontWeight.w600),
                        ),
                        subtitle: Padding(
                          padding:
                              const EdgeInsets.only(top: 4),
                          child: Text(
                            fav.category,
                            style: const TextStyle(
                                color: Colors.grey),
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
