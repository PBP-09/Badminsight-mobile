import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:badminsights_mobile/player_list/models/player_entry.dart'; 

class PlayerEntryCard extends StatelessWidget {
  final PlayerEntry player;
  final VoidCallback onTap;

  const PlayerEntryCard({
    super.key,
    required this.player,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String countryName = player.country; 
    String bioText = player.bio;

    String categoryName = categoryValues.reverse[player.category] ?? "";
    String statusName = statusValues.reverse[player.status] ?? "";
    
    String formattedDate = DateFormat('dd MMM yyyy').format(player.dateOfBirth);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoryName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (player.isFeatured)
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: player.thumbnail != null && player.thumbnail!.isNotEmpty
                              ? Image.network(
                                  player.thumbnail!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => _buildNoImage(),
                                )
                              : _buildNoImage(),
                        ),
                        const SizedBox(width: 16),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.public, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(countryName),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.emoji_events, size: 14, color: Color(0xFFB45309)),
                                  const SizedBox(width: 4),
                                  Text(
                                    player.worldRank != null ? "Rank #${player.worldRank}" : "Unranked",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildStatusChip(statusName),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    const Text(
                      "BIO",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bioText.isEmpty ? "No biography available." : bioText,
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),

                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        const Icon(Icons.cake_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          "Born: $formattedDate",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[200],
      child: const Icon(Icons.person, color: Colors.grey, size: 40),
    );
  }

  Widget _buildStatusChip(String status) {
    bool isActive = status.toLowerCase() == "active";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isActive ? Colors.green : Colors.red, width: 0.5),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}