import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:badminsights_mobile/left_drawer.dart'; 

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
                // Tembak ke auth/register/
                final response = await request.post("http://localhost:8000/auth/register/", {
                  'username': _usernameController.text,
                  'password1': _passwordController.text,
                  'password2': _confirmPasswordController.text,
                });

                if (response['status'] == 'success') {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registrasi Berhasil! Silakan Login.")),
                    );
                    Navigator.pop(context); // Balik ke halaman Login
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'] ?? "Registrasi Gagal")),
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