import 'dart:async';
import 'package:flutter/material.dart';
import 'package:badminsights_mobile/smash_talk/screens/forum_list_page.dart';

class SmashTalkSplash extends StatefulWidget {
  const SmashTalkSplash({super.key});

  @override
  State<SmashTalkSplash> createState() => _SmashTalkSplashState();
}

class _SmashTalkSplashState extends State<SmashTalkSplash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _shuttlecockAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Jalur Smash: Dari sangat jauh di kiri bawah ke sangat jauh di kanan atas
    // Kita pake angka besar (10.0) biar dia bener-bener "lewat" di layar lebar/web
    _shuttlecockAnimation = Tween<Offset>(
      begin: const Offset(-8.0, 8.0), 
      end: const Offset(8.0, -8.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    // Fade In buat teks
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeIn)),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim, anim2) => const ForumListPage(),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (context, a, b, child) => FadeTransition(opacity: a, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Warna dasar Navy
      body: Stack(
        alignment: Alignment.center, // SEMUA BARANG PATOKANNYA TENGAH
        children: [
          // 1. Background Gradient yang menutupi layar
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
              ),
            ),
          ),

          // 2. Efek Cahaya Kecepatan (Ganti Bolt yang tadinya kegedean)
          Transform.rotate(
            angle: 0.8,
            child: Container(
              width: 2,
              height: MediaQuery.of(context).size.height * 2,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  )
                ],
              ),
            ),
          ),

          // 3. TEKS UTAMA (Bener-bener di Center)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Biar nggak makan ruang vertikal
              children: [
                const Text(
                  "SMASH TALK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48, // Lebih gede biar mantap
                    fontWeight: FontWeight.w900,
                    letterSpacing: 10,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 20)
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 4,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(color: Colors.yellowAccent.withOpacity(0.5), blurRadius: 10)
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "COMMUNITY DISCUSSION",
                  style: TextStyle(
                    color: Colors.white70, 
                    fontSize: 14, 
                    letterSpacing: 6, 
                    fontWeight: FontWeight.w300
                  ),
                ),
              ],
            ),
          ),

          // 4. ANIMASI RAKET/BALL (Meluncur di atas teks)
          Center( // Dikasih Center lagi biar offsetnya ngitung dari titik tengah
            child: SlideTransition(
              position: _shuttlecockAnimation,
              child: Transform.rotate(
                angle: -0.5,
                child: const Icon(
                  Icons.sports_tennis_rounded, 
                  color: Colors.yellowAccent, 
                  size: 80,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}