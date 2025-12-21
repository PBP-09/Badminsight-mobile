import 'package:flutter/material.dart';
import 'package:badminsights_mobile/main_features/menu.dart';
import 'package:badminsights_mobile/smash_talk/screens/forum_list_page.dart'; // Import SmashTalk
import 'package:badminsights_mobile/badminews/screens/news_list_screen.dart'; // Import BadmiNews
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF9FAFB),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header dengan tema biru tua (Primary)
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A), 
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_tennis, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  'Badminsights',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'All Things Badminton, in One Place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Menu Utama
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Color(0xFF1E3A8A)),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),

          // Menu yang warnanya sesuai dengan tombol di Menu Utama
          ListTile(
            leading: const Icon(Icons.person_search_outlined, color: Color(0xFF1E3A8A)),
            title: const Text("Who's on Court?"),
            onTap: () {
              // Navigasi fitur player
            },
          ),

          ListTile(
            leading: const Icon(Icons.message_outlined, color: Color(0xFF0D9488)),
            title: const Text('SmashTalk'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ForumListPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.newspaper_outlined, color: Color(0xFFB45309)),
            title: const Text('BadmiNews'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NewsListScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.shopping_cart_outlined, color: Color(0xFFBE123C)),
            title: const Text('Merch Store'),
            onTap: () {
              // Navigasi fitur merchandise
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.favorite_border, color: Colors.grey),
            title: const Text('Pemain Favorit Saya'),
            onTap: () {
              // Navigasi fitur favorit (hanya muncul jika request.user.is_authenticated)
            },
          ),
        ],
      ),
    );
  }
}