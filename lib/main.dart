import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // WAJIB IMPORT
import 'package:provider/provider.dart'; // WAJIB IMPORT
import 'package:badminsights_mobile/main_features/menu.dart';

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
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            secondary: Color.fromARGB(255, 211, 206, 202),
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}