import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/left_drawer.dart'; 
import 'package:badminsights_mobile/smash_talk/screens/forum_list_page.dart';
import 'package:badminsights_mobile/katalog/screens/katalog_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Badminsights Mobile',
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: const Color(0xFFF8F7F4),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const LandingPage(),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: const LeftDrawer(),
      appBar: AppBar(
        title: const Text('Badminsights'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            ModuleCard(
              icon: Icons.forum,
              title: 'SmashTalk',
              route: ForumListPage(),
            ),
            ModuleCard(
              icon: Icons.shopping_bag,
              title: 'Merch',
              route: KatalogListPage(),
            ),
            ModuleCard(
              icon: Icons.article,
              title: 'BadmiNews',
              route: PlaceholderPage(title: 'BadmiNews'),
            ),
            ModuleCard(
              icon: Icons.favorite,
              title: 'Pemain Favorit',
              route: PlaceholderPage(title: 'Favorit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget route;

  const ModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => route),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title belum diimplementasi'),
      ),
    );
  }
}
