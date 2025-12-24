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
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animasi Shuttlecock meluncur kenceng (Smash!)
    _shuttlecockAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 2.0), // Dari luar layar kiri bawah
      end: const Offset(2.0, -2.0),   // Ke luar layar kanan atas
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    // Animasi teks muncul pelan (Fade In)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();

    // Pindah ke halaman Forum asli setelah 2 detik
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const ForumListPage(),
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)], // Navy ke Blue
          ),
        ),
        child: Stack(
          children: [
            // Efek Garis Kecepatan (Speed Lines)
            Center(
              child: Opacity(
                opacity: 0.1,
                child: Icon(Icons.bolt, size: MediaQuery.of(context).size.width, color: Colors.white),
              ),
            ),

            // ANIMASI SHUTTLECOCK MELUNCUR
            SlideTransition(
              position: _shuttlecockAnimation,
              child: const Icon(Icons.sports_tennis_rounded, color: Colors.yellowAccent, size: 60),
            ),

            // TEKS TENGAH
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "SMASH TALK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Container(
                      height: 4,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "COMMUNITY DISCUSSION",
                      style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}