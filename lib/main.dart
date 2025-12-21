import 'package:flutter/material.dart';
import 'package:badminsights_mobile/main_features/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'Badminsights Mobile',
        theme: ThemeData(
          primaryColor: const Color(0xFF2C3E50),
          scaffoldBackgroundColor: const Color(0xFFF8F7F4),
          cardColor: Colors.white,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}


class ModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget route;

  const ModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => route),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}