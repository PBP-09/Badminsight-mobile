import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:badminsights_mobile/left_drawer.dart'; 
import 'package:badminsights_mobile/authentication/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      drawer: const LeftDrawer(), 
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            TextField(controller: _confirmPasswordController, decoration: const InputDecoration(labelText: 'Confirm Password'), obscureText: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
  String username = _usernameController.text;
  String password = _passwordController.text;
  String confirmPassword = _confirmPasswordController.text;

  // Validasi sederhana di client biar cepet
  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Username dan password tidak boleh kosong")),
    );
    return;
  }

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password tidak cocok")),
    );
    return;
  }

  try {
    // 1. Pake 127.0.0.1 (lebih stabil di Chrome dibanding localhost)
    // 2. WAJIB pake garis miring '/' di akhir biar gak di-redirect Django
    final response = await request.post("http://127.0.0.1:8000/auth/register/", {
      'username': username,
      'password1': password,
      'password2': confirmPassword,
    });

    if (context.mounted) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi Berhasil! Silakan Login.")),
        );
        // Pindah ke LoginPage, bukan pop (biar pasti ke halaman login)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Registrasi Gagal")),
        );
      }
    }
  } catch (e) {
    // Biar lu tau error aslinya apa di debug console
    print("Error pas register: $e");
    if (context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Terjadi kesalahan koneksi ke server.")),
       );
    }
  }
},
              child: const Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}