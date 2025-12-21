import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/main.dart'; // Import halaman LandingPage
import 'package:badminsights_mobile/authentication/login.dart'; // Pastikan path Login benar
import 'package:badminsights_mobile/smash_talk/screens/forum_list_page.dart';

// --- IMPORT HALAMAN TEMAN KELOMPOK DI SINI ---
// import 'package:badminsights_mobile/whos_on_court/screens/player_list.dart';
// import 'package:badminsights_mobile/badminews/screens/news_list.dart';
// import 'package:badminsights_mobile/katalog/screens/katalog_list.dart';
// import 'package:badminsights_mobile/bookmark/screens/bookmark_page.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Drawer(
      child: ListView(
        children: [
          // === HEADER DRAWER ===
          const UserAccountsDrawerHeader(
            accountName: Text("Badminsights", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text("All Things Badminton, in One Place."),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.sports_tennis, size: 40, color: Color(0xFF2C3E50)),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF2C3E50), // Warna Tema Utama
            ),
          ),

          // === MENU NAVIGASI ===
          
          // 1. HOME
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LandingPage()),
              );
            },
          ),

          // 2. WHO'S ON COURT (Pemain)
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text("Who's on Court?"),
            onTap: () {
              // GANTI DENGAN HALAMAN PEMAIN TEMAN LU
              /*
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PlayerListPage()),
              );
              */
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Modul Pemain belum di-import")));
            },
          ),

          // 3. SMASH TALK (Forum Lu)
          ListTile(
            leading: const Icon(Icons.forum_outlined),
            title: const Text('SmashTalk'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ForumListPage()),
              );
            },
          ),

          // 4. BADMIN NEWS
          ListTile(
            leading: const Icon(Icons.newspaper_outlined),
            title: const Text('BadmiNews'),
            onTap: () {
              // GANTI DENGAN HALAMAN BERITA TEMAN LU
              /*
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NewsListPage()),
              );
              */
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Modul Berita belum di-import")));
            },
          ),

          // 5. KATALOG MERCH
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Katalog Merch'),
            onTap: () {
              // GANTI DENGAN HALAMAN MERCH TEMAN LU
              /*
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const KatalogPage()),
              );
              */
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Modul Katalog belum di-import")));
            },
          ),

          const Divider(), // Garis pemisah

          // === BAGIAN AUTHENTICATION ===
          
          if (!request.loggedIn) ...[
            // TAMPILKAN JIKA BELUM LOGIN
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ] else ...[
            // TAMPILKAN JIKA SUDAH LOGIN
            
            // Menu Tambahan: Favorit (Hanya user login)
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Pemain Favorit'),
              onTap: () {
                /*
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BookmarkPage()),
                );
                */
              },
            ),
            
            // Tombol Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                final response = await request.logout(
                  "http://127.0.0.1:8000/auth/logout/" // Ganti URL sesuai endpoint logout Django lu
                );
                String message = response["message"];
                if (context.mounted) {
                  if (response['status']) {
                    String uname = response["username"];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$message Sampai jumpa, $uname.")),
                    );
                    // Redirect ke Home/Login setelah logout
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}