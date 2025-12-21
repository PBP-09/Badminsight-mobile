import 'package:flutter/material.dart';
import 'package:badminsights_mobile/authentication/login.dart';
import 'package:badminsights_mobile/player_list/screens/player_form.dart'; // Import form
import 'package:badminsights_mobile/player_list/screens/player_entry_list.dart'; // Import list
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:badminsights_mobile/main_features/menu.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () async {
          // Menampilkan pesan snackbar setiap kali tombol ditekan
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("Membuka ${item.name}...")));

          // LOGIKA NAVIGASI
          if (item.name == "Tambah Pemain") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlayerFormPage()),
            );
          } 
          else if (item.name == "Who's on Court?") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlayerEntryListPage()),
            );
          } 
          else if (item.name == "Logout") {
            // Sesuaikan URL dengan endpoint logout di Django kamu
            final response = await request.logout(
                "http://localhost:8000/auth/logout/");
            
            String message = response["message"];
            
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa lagi, $uname."),
                ));
                // Kembali ke halaman Login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
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