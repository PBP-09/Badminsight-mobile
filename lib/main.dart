import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Jangan lupa ini
import 'package:provider/provider.dart'; // Dan ini
import 'package:badminsights_mobile/authentication/login.dart';
import 'package:badminsights_mobile/smash_talk/screens/forum_list_page.dart'; // Sesuaikan path ini
import 'package:badminsights_mobile/left_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // === BAGIAN PENTING: BUNGKUS DENGAN PROVIDER ===
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Badminsights Mobile',
        theme: ThemeData(
          // ... theme lu yang tadi ...
          primaryColor: const Color(0xFF2C3E50),
          scaffoldBackgroundColor: const Color(0xFFF8F7F4),
          cardColor: Colors.white,
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              fontFamily: 'serif',
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFF8492A6),
            ),
            titleMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'All Things Badminton, in One Place.',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Discover detailed player bios, explore official merch, and join discussions with badminton fans worldwide — only on Badminsights.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigate to Players')),
                      );
                    },
                    child: const Text('Explore Players'),
                  ),
                ],
              ),
            ),

            // Featured Player Section
            const FeaturedPlayerCard(),

            // Module Grid
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  ModuleCard(
                    icon: Icons.forum,
                    title: 'SmashTalk',
                    description: 'Forum untuk bertanya, berbagi pengalaman.',
                    routeName: 'forum',
                  ),
                  ModuleCard(
                    icon: Icons.article,
                    title: 'BadmiNews',
                    description: 'Temukan berita terbaru seputar dunia badminton.',
                    routeName: 'news',
                  ),
                  ModuleCard(
                    icon: Icons.shopping_bag,
                    title: 'Merch',
                    description: 'Temukan perlengkapan badminton terbaik.',
                    routeName: 'merch',
                  ),
                  ModuleCard(
                    icon: Icons.favorite,
                    title: 'Pemain Favorit',
                    description: 'Lihat daftar pemain yang sudah Anda tandai.',
                    routeName: 'favorites',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedPlayerCard extends StatelessWidget {
  const FeaturedPlayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Featured Player',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Profil pemain pilihan minggu ini.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Women\'s Single',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Player Name',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Country: Indonesia'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Rank: #1'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigate to Player Profile')),
                    );
                  },
                  child: const Text('Lihat Profil Lengkap'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === BAGIAN PENTING: Class ModuleCard yang sudah diperbaiki tombolnya ===
class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.routeName,
  });

  final IconData icon;
  final String title;
  final String description;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    // Fungsi navigasi yang dipanggil di InkWell dan Button
    void navigate() {
      if (routeName == 'forum') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForumListPage()),
        );
      } else if (routeName == 'news') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('News coming soon!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigate to $title')),
        );
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: navigate, // Navigasi saat kartu diklik
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Theme.of(context).primaryColor),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 10),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: navigate, // Navigasi saat tombol diklik
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    textStyle: const TextStyle(fontSize: 10),
                  ),
                  child: const Text('Selengkapnya'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman sementara sebelum lu buat LoginPage
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BadminSights")),
      body: const Center(child: Text("Silakan buat LoginPage di folder authentication")),
    );
  }
}