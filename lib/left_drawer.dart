import 'package:flutter/material.dart';
import 'package:badminsights_mobile/main_features/menu.dart';
import 'package:badminsights_mobile/smash_talk/screens/forum_list_page.dart'; // Import SmashTalk
import 'package:badminsights_mobile/badminews/screens/news_list_screen.dart'; // Import BadmiNews
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:badminsights_mobile/authentication/login.dart';
import 'package:badminsights_mobile/authentication/register.dart';
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF9FAFB),
      child: Consumer<CookieRequest>(
        builder: (context, request, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
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

              const Divider(),

              // Authentication Section
              if (request.loggedIn) ...[
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFF1E3A8A)),
                  title: Text('Hi, ${request.jsonData['username'] ?? 'User'}'),
                  subtitle: const Text('Logged in'),
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout'),
                  onTap: () async {
                    final response = await request.logout("http://127.0.0.1:8000/auth/logout/");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'] ?? "Logged out")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );
                    }
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.login, color: Color(0xFF1E3A8A)),
                  title: const Text('Login'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add, color: Color(0xFF0D9488)),
                  title: const Text('Register'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}