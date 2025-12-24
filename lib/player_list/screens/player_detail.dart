import 'package:flutter/material.dart';
import 'package:badminsights_mobile/player_list/models/player_entry.dart';
import 'package:badminsights_mobile/bookmark/widgets/bookmark_button.dart'; 
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PlayerDetailPage extends StatelessWidget {
  final PlayerEntry player;

  const PlayerDetailPage({super.key, required this.player});

  // Fungsi untuk mengirim data bookmark ke Django
  Future<void> toggleBookmark(CookieRequest request, BuildContext context) async {
    final response = await request.post(
      "https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/bookmark/add-flutter/", 
      {
        "player_id": player.id.toString(),
      },
    );

    if (context.mounted) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Berhasil memperbarui favorit"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal memperbarui favorit. Silakan coba lagi."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    String countryName = countryValues.reverse[player.country] ?? "";
    String categoryName = categoryValues.reverse[player.category] ?? "";
    String statusName = statusValues.reverse[player.status] ?? "";
    String bioText = bioValues.reverse[player.bio] ?? "";
    String formattedBirthDate = DateFormat('dd MMMM yyyy').format(player.dateOfBirth);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Player Profile'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Section
            _buildHeaderImage(categoryName),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row Nama dan Bintang Featured
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          player.name,
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                      if (player.isFeatured)
                        const Icon(Icons.stars, color: Colors.amber, size: 30),
                    ],
                  ),
                  
                  const SizedBox(height: 16),

                  BookmarkButton(
                    isBookmarked: false, // Default false, atau bisa di-fetch dulu statusnya
                    onPressed: () => toggleBookmark(request, context),
                  ),

                  const SizedBox(height: 20),
                  _buildStatusChip(statusName),
                  const Divider(height: 40),

                  // Stat Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(Icons.leaderboard, "World Rank", 
                          player.worldRank != null ? "#${player.worldRank}" : "N/A"),
                      _buildStatItem(Icons.public, "Country", countryName),
                      _buildStatItem(Icons.cake, "Born", DateFormat('yyyy').format(player.dateOfBirth)),
                    ],
                  ),

                  const Divider(height: 40),

                  // Biography Section
                  const Text(
                    "Biography",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bioText.isEmpty ? "No biography available for this player." : bioText,
                    style: const TextStyle(fontSize: 16.0, height: 1.6, color: Colors.black87),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 24),
                  _buildInfoRow("Full Birth Date", formattedBirthDate),
                  _buildInfoRow("Partner ID", player.partnerId ?? "No active partner"),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Header Image
  Widget _buildHeaderImage(String category) {
    return Stack(
      children: [
        if (player.thumbnail != null && player.thumbnail!.isNotEmpty)
          Image.network(
            player.thumbnail!,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          )
        else
          _buildPlaceholder(),
        
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              category.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 300,
      color: Colors.grey[300],
      child: const Center(child: Icon(Icons.person, size: 100, color: Colors.grey)),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFB45309)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    bool isActive = status.toLowerCase() == "active";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? Colors.green : Colors.red),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: isActive ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}