import 'package:flutter/material.dart';
import 'package:badminsights_mobile/player_list/models/player_entry.dart';
import 'package:badminsights_mobile/left_drawer.dart';
import 'package:badminsights_mobile/player_list/widgets/player_entry_card.dart';
import 'package:badminsights_mobile/player_list/screens/player_detail.dart'; // Pastikan path import benar
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/left_drawer.dart'; 


class PlayerEntryListPage extends StatefulWidget {
  const PlayerEntryListPage({super.key});

  @override
  State<PlayerEntryListPage> createState() => _PlayerEntryListPageState();
}

class _PlayerEntryListPageState extends State<PlayerEntryListPage> {
  // Fungsi untuk mengambil data dari backend Django
  Future<List<PlayerEntry>> fetchPlayers(CookieRequest request) async {
    // Ganti URL sesuai dengan environment Anda (localhost/10.0.2.2)
    final response = await request.get('http://rousan-chandra-badminsights.pbp.cs.ui.ac.id/json/');

    List<PlayerEntry> listPlayers = [];
    for (var d in response) {
      if (d != null) {
        listPlayers.add(PlayerEntry.fromJson(d));
      }
    }
    return listPlayers;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Who\'s on Court?',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchPlayers(request),
        builder: (context, AsyncSnapshot<List<PlayerEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
            );
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_tennis, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    const Text(
                      'No players found yet.',
                      style: TextStyle(fontSize: 18, color: Color(0xFF1E3A8A)),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final player = snapshot.data![index];
                  
                  // Menggunakan Widget Card yang sudah kita buat sebelumnya
                  return PlayerEntryCard(
                    player: player,
                    onTap: () {
                      // NAVIGASI KE DETAIL
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerDetailPage(player: player),
                        ),
                      );
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}