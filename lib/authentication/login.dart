import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:badminsights_mobile/authentication/register.dart';
import 'package:badminsights_mobile/main_features/menu.dart';
import 'dart:convert';
import 'package:badminsights_mobile/main_splash_screen.dart'; 
import 'package:badminsights_mobile/authentication/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Badminsights", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // === BACKGROUND THEME SPORTY ===
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFFF1F5F9)],
            stops: [0.0, 0.2, 0.5],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Badminton
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.sports_tennis_rounded, size: 60, color: Color(0xFF1E3A8A)),
                ),
                const SizedBox(height: 24),

                // === KARTU LOGIN UTAMA ===
                Card(
                  elevation: 20,
                  shadowColor: Colors.black45,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 8),
                        const Text('Sign in to smash some insights!', style: TextStyle(color: Colors.blueGrey)),
                        const SizedBox(height: 32.0),

                        // Input Username
                        _buildTextField(_usernameController, 'Username', Icons.person_outline),
                        const SizedBox(height: 16.0),
                        
                        // Input Password
                        _buildTextField(_passwordController, 'Password', Icons.lock_outline, isPassword: true),
                        const SizedBox(height: 32.0),

                        // === 1. TOMBOL LOGIN (ANIMASI) ===
                        PressableScale(
                          onTap: _isLoading ? () {} : () async {
                            setState(() => _isLoading = true);
                            
                            // Ganti ke https kalau nanti mau demo pake PWS
                            final response = await request.login("https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/auth/login/", {
                              'username': _usernameController.text,
                              'password': _passwordController.text,
                            });

                            AuthState.isAdmin = response != null && response['is_staff'] == true;

                            if (request.loggedIn) {
                              if (context.mounted) {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainSplashScreen()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Login Success! Let's play."), backgroundColor: Colors.blue),
                                );
                              }
                            } else {
                              setState(() => _isLoading = false);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response['message']), backgroundColor: Colors.redAccent),
                                );
                              }
                            }
                          },
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))
                              ],
                            ),
                            child: Center(
                              child: _isLoading 
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20.0),

                        // === 2. LINK KE REGISTER (DIBIKIN JELAS) ===
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Baru di sini?", style: TextStyle(color: Colors.grey)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                              },
                              child: const Text("Register Sekarang", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                            ),
                          ],
                        ),

                        const Divider(height: 30, thickness: 0.5),

                        // === 3. TOMBOL GUEST ===
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainSplashScreen()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Browsing as Guest. Login to interact!")),
                            );
                          },
                          icon: const Icon(Icons.visibility_outlined, size: 18, color: Colors.blueGrey),
                          label: const Text(
                            "Continue as Guest",
                            style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2563EB), size: 22),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}

// === WIDGET ANIMASI SCALE (PENCET) ===
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const PressableScale({super.key, required this.child, required this.onTap});

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100), lowerBound: 0.0, upperBound: 0.05);
    super.initState();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) { _controller.reverse(); widget.onTap(); },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(_controller),
        child: widget.child,
      ),
    );
  }
}