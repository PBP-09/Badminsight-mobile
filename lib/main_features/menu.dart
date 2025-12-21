import 'dart:async';
import 'package:flutter/material.dart';
import 'package:badminsights_mobile/left_drawer.dart';
import 'package:badminsights_mobile/smash_talk/screens/forum_list_page.dart';
import 'package:badminsights_mobile/badminews/screens/news_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/katalog/screens/katalog_list_page.dart';
import 'package:badminsights_mobile/authentication/login.dart';
import 'package:badminsights_mobile/authentication/register.dart';
import 'package:badminsights_mobile/player_list/screens/player_entry_list.dart';

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

  // Variabel State
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  
  List<dynamic> _players = []; // Simpan data pemain di sini
  bool _isLoading = true; // Status loading
  bool _isInit = false; // Penanda biar fetch cuma sekali

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  // Fungsi Fetch yang Dijalankan SEKALI SAJA
  Future<void> _initData() async {
    final request = context.read<CookieRequest>(); // Pakai read biar gak rebuild loop
    try {
      // Ganti URL sesuai environment (127.0.0.1 untuk Chrome)
      final response = await request.get('http://127.0.0.1:8000/api/players/');
      
      if (mounted) {
        setState(() {
          _players = response;
          _isLoading = false;
        });
        // Mulai Timer setelah data ada
        _startAutoScroll();
      }
    } catch (e) {
      print("Error fetching players: $e");
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading meski error
        });
      }
    }
  }

  // Dipanggil saat widget pertama kali dibuat & punya akses ke context
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _initData();
      _isInit = true;
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    if (_players.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _players.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
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
    _timer?.cancel();
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
        actions: [
          Consumer<CookieRequest>(
            builder: (context, request, child) {
              if (request.loggedIn) {
                return Row(
                  children: [
                    Text(
                      'Hi, ${request.jsonData['username'] ?? 'User'}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () async {
                        final response = await request.logout("http://127.0.0.1:8000/auth/logout/");
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response['message'] ?? "Logged out")),
                          );
                        }
                      },
                      tooltip: 'Logout',
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
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
                          color: Colors.black.withOpacity(0.05), blurRadius: 10)
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
                            color: Color(0xFF1E3A8A)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover player bios, explore merch, and join discussions worldwide.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
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

              // 3. Title Pemain Sorotan
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Pemain Sorotan",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A)),
                ),
              ),

              const SizedBox(height: 12.0),

              // 4. CAROUSEL (Pakai Data State, Bukan FutureBuilder di Build)
              SizedBox(
                height: 220,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _players.isEmpty
                        ? const Center(child: Text("Belum ada data pemain."))
                        : PageView.builder(
                            controller: _pageController,
                            itemCount: _players.length,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            itemBuilder: (context, index) {
                              final player = _players[index];
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

  // WIDGET KARTU CAROUSEL (Simple & Aman)
  Widget _buildPlayerCarouselCard(dynamic player) {
    String name = player['name'] ?? "Unknown";
    String category = player['category'] ?? "General";
    String rank = player['rank'] ?? "Unranked";
    String thumbnail = player['thumbnail'] ?? "";

    Widget imageWidget;
    
    if (thumbnail.isEmpty) {
      imageWidget = Container(
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.person, size: 50, color: Colors.grey)),
      );
        } else {
      // 1. Fix URL Localhost (Standar)
      if (thumbnail.contains('10.0.2.2')) {
        thumbnail = thumbnail.replaceAll('10.0.2.2', '127.0.0.1');
      }

      // 2. JURUS BARU: PAKE 'wsrv.nl' (Lebih Sakti dari Corsproxy)
      // Ini layanan khusus buat nampilin gambar web yg kena blokir
      if (thumbnail.startsWith('http') && !thumbnail.contains('127.0.0.1')) {
         // Hapus 'https://' dulu kalau dobel, tapi biar aman kita encode aja
         thumbnail = "https://wsrv.nl/?url=${Uri.encodeComponent(thumbnail)}";
      }

      imageWidget = Image.network(
        thumbnail,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade300,
          child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
        ),
      );
    }

    // ... (Sisa kode return Container ke bawah SAMA SAJA, tidak perlu diubah) ...
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageWidget,
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.ellipsis),
                  Row(children: [
                      Flexible(child: Text("$rank • $category", style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis)),
                  ])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ... Class ItemHomepage dan ItemCard Biarkan Seperti Semula ...
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
          } else if (item.name == "BadmiNews") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewsListScreen()),
            );
          } else if (item.name == "Merch") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KatalogListPage()),
            );
          }else if (item.name == "Who's on Court?") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlayerEntryListPage()),
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