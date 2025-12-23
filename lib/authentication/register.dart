import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:badminsights_mobile/authentication/login.dart';
import 'package:badminsights_mobile/main_features/menu.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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
        // === BACKGROUND THEME SPORTY (SAMA DENGAN LOGIN) ===
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

                // === KARTU REGISTER UTAMA ===
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
                          'Create Account',
                          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 8),
                        const Text('Join the smash community today!', style: TextStyle(color: Colors.blueGrey)),
                        const SizedBox(height: 32.0),

                        // Input Username
                        _buildTextField(_usernameController, 'Username', Icons.person_outline),
                        const SizedBox(height: 16.0),
                        
                        // Input Password
                        _buildTextField(_passwordController, 'Password', Icons.lock_outline, isPassword: true),
                        const SizedBox(height: 16.0),

                        // Input Confirm Password
                        _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock_reset_outlined, isPassword: true),
                        const SizedBox(height: 32.0),

                        // === 1. TOMBOL REGISTER (ANIMASI) ===
                        PressableScale(
                          onTap: _isLoading ? () {} : () async {
                            String username = _usernameController.text;
                            String password1 = _passwordController.text;
                            String password2 = _confirmPasswordController.text;

                            if (username.isEmpty || password1.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Field tidak boleh kosong!")));
                              return;
                            }

                            if (password1 != password2) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password tidak cocok!")));
                              return;
                            }

                            setState(() => _isLoading = true);
                            
                            // Ganti ke https kalau nanti mau demo pake PWS
                            final response = await request.post("http://localhost:8000/auth/register/", {
                              'username': username,
                              'password1': password1,
                              'password2': password2,
                            });

                            if (context.mounted) {
                              if (response['status'] == 'success' || response['status'] == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Account created! Please login."), backgroundColor: Colors.green),
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                              } else {
                                setState(() => _isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response['message'] ?? "Registration failed"), backgroundColor: Colors.redAccent),
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
                                : const Text('Register Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20.0),

                        // === 2. LINK KE LOGIN (DIBIKIN JELAS) ===
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Sudah punya akun?", style: TextStyle(color: Colors.grey)),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Balik ke page Login
                              },
                              child: const Text("Login di sini", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                            ),
                          ],
                        ),

                        const Divider(height: 30, thickness: 0.5),

                        // === 3. TOMBOL GUEST ===
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
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

  // Helper input style (SAMA DENGAN LOGIN)
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

// === WIDGET ANIMASI SCALE (SAMA DENGAN LOGIN) ===
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