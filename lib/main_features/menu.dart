import 'dart:async'; // Buat Timer animasi
import 'package:flutter/material.dart';
import 'package:badminsights_mobile/left_drawer.dart'; 
import 'package:badminsights_mobile/smash_talk/screens/forum_list_page.dart'; 
import 'package:badminsights_mobile/katalog/screens/katalog_list_page.dart';


// UBAH JADI STATEFUL WIDGET BIAR BISA GERAK SENDIRI
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ItemHomepage> items = [
    ItemHomepage("Who's on Court?", Icons.person, const Color(0xFF1E3A8A)),
    ItemHomepage("SmashTalk", Icons.message, const Color(0xFF0D9488)),
    ItemHomepage("BadmiNews", Icons.newspaper, const Color(0xFFB45309)),
    ItemHomepage("Merch", Icons.shop, const Color(0xFFBE123C)),
  ];

  // DATA PEMAIN (Link Gambar Diganti yang Stabil)
    final List<Map<String, String>> featuredPlayers = [
    {
      "name": "Kevin Sanjaya",
      "rank": "MD Rank 1 (Ex)",
      // Link Wikimedia (Aman buat Web)
      "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Kevin_Sanjaya_Sukamuljo_at_Indonesian_Masters_2018.jpg/640px-Kevin_Sanjaya_Sukamuljo_at_Indonesian_Masters_2018.jpg"
    },
    {
      "name": "Jonatan Christie",
      "rank": "MS Rank 3",
      "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Jonatan_Christie_%28INA%29.jpg/640px-Jonatan_Christie_%28INA%29.jpg"
    },
    {
      "name": "Gregoria Mariska",
      "rank": "WS Rank 7",
      "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Gregoria_Mariska_Tunjung_Kagoshima_2023.jpg/640px-Gregoria_Mariska_Tunjung_Kagoshima_2023.jpg"
    },
    {
      "name": "Fajar Alfian",
      "rank": "MD Rank 1",
      "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Fajar_Alfian_Indonesia_Masters_2022.jpg/640px-Fajar_Alfian_Indonesia_Masters_2022.jpg"
    },
  ];

  // Variabel untuk Animasi Carousel
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Controller biar kelihatan sedikit item selanjutnya (viewport 0.85)
    _pageController = PageController(viewportFraction: 0.85);
    
    // Timer biar geser otomatis tiap 3 detik
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < featuredPlayers.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Balik ke awal kalau udah mentok
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Matikan timer pas keluar halaman biar gak error
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), 
      appBar: AppBar(
        title: const Text(
          'Badminsights',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E3A8A), 
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      drawer: const LeftDrawer(), 
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              // 1. Hero Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'All Things Badminton, in One Place.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover player bios, explore merch, and join discussions worldwide.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // 2. Menu Buttons
              Center(
                child: Wrap(
                  spacing: 12.0, 
                  runSpacing: 12.0, 
                  alignment: WrapAlignment.center,
                  children: items.map((ItemHomepage item) {
                    return ItemCard(item);
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32.0),

              // 3. TITLE PEMAIN SOROTAN (Tanpa Lihat Semua)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Pemain Sorotan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                ),
              ),
              
              const SizedBox(height: 12.0),

              // 4. CAROUSEL OTOMATIS (PAGEVIEW)
              SizedBox(
                height: 200, // Tinggi kartu
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: featuredPlayers.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final player = featuredPlayers[index];
                    return _buildPlayerCarouselCard(player);
                  },
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET KARTU CAROUSEL (GEDE + GAMBAR FULL)
  Widget _buildPlayerCarouselCard(Map<String, String> player) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0), // Jarak antar kartu
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          // GAMBAR FULL BACKGROUND
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              player['image']!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
              ),
            ),
          ),
          
          // GRADIENT HITAM DI BAWAH (Biar tulisan kebaca)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player['name']!,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 18
                    ),
                  ),
                  Text(
                    player['rank']!,
                    style: const TextStyle(
                      color: Colors.white70, 
                      fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(8), 
      child: InkWell(
        onTap: () {
          if (item.name == "SmashTalk") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForumListPage()),
            );
          } 
          else if (item.name == "Merch") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KatalogListPage()),
            );
          }
          else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Membuka ${item.name}... (Coming Soon)")));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          constraints: const BoxConstraints(minWidth: 140), 
          child: Row( 
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                item.name,
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}