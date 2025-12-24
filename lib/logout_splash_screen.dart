import 'dart:async';
import 'package:flutter/material.dart';
import 'package:badminsights_mobile/main_splash_screen.dart'; // Import splash utama lo

class LogoutSplashScreen extends StatefulWidget {
  const LogoutSplashScreen({super.key});

  @override
  State<LogoutSplashScreen> createState() => _LogoutSplashScreenState();
}

class _LogoutSplashScreenState extends State<LogoutSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _shuttlecockExitAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animasi Shuttlecock melesat keluar (Exit)
    _shuttlecockExitAnimation = Tween<Offset>(
      begin: Offset.zero, 
      end: const Offset(4.0, -4.0), // Meluncur jauh ke kanan atas
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInBack));

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward();

    // Tunggu 2 detik baru balik ke Intro/Main Splash Screen
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => const MainSplashScreen(),
            transitionDuration: const Duration(milliseconds: 1000),
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)], // Balikin Navy-nya (Inverted)
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Konten Teks
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "LOGGING OUT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "See you next time, Smasher!",
                    style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 2),
                  ),
                ],
              ),
            ),

            // Animasi Shuttlecock Terbang Menjauh
            SlideTransition(
              position: _shuttlecockExitAnimation,
              child: Transform.rotate(
                angle: 0.5,
                child: const Icon(
                  Icons.sports_tennis_rounded,
                  color: Colors.yellowAccent,
                  size: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}