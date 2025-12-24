import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/katalog.dart';
import 'katalog_edit_page.dart';
import 'katalog_delete_page.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/authentication/auth_state.dart';



class KatalogDetailPage extends StatelessWidget {
  final int productId;
  const KatalogDetailPage({super.key, required this.productId});

  Future<Katalog> fetchDetail() async {
    final res = await http.get(
      Uri.parse('https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/katalog/json/'),
    );
    return katalogFromJson(res.body)
        .firstWhere((e) => e.id == productId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: FutureBuilder<Katalog>(
        future: fetchDetail(),
        builder: (context, s) {
          if (!s.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final p = s.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.network(
                          p.imageUrl.isNotEmpty ? p.imageUrl : 'invalid',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image_not_supported,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('No Image',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildDetailContent(context, p),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.network(
                            p.imageUrl.isNotEmpty ? p.imageUrl : 'invalid',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.image_not_supported,
                                        size: 64, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text('No Image',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(child: buildDetailContent(context, p)),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget buildDetailContent(BuildContext context, Katalog p) {
  final isAdmin = AuthState.isAdmin; 

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(p.name,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(p.category, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 12),
      Text('Rp ${p.price}',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Text(p.description),
      const SizedBox(height: 12),
      Text('Stok: ${p.stock} | Rating: ${p.rating} / 5',
          style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 24),

      if (isAdmin)
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KatalogEditPage(product: p),
                  ),
                );
              },
              child: const Text('Edit'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) =>
                      KatalogDeletePage(productId: p.id),
                );
                if (result == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        ),
    ],
  );
 }
}
