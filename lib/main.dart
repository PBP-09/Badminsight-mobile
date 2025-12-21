import 'package:flutter/material.dart';
import 'package:badminsights_mobile/main_features/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:badminsights_mobile/smash_talk/screens/forum_list_page.dart';
import 'package:badminsights_mobile/katalog/screens/katalog_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'Badminsights Mobile',
        theme: ThemeData(
          primaryColor: const Color(0xFF2C3E50),
          scaffoldBackgroundColor: const Color(0xFFF8F7F4),
          cardColor: Colors.white,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badminsights'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => route),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
