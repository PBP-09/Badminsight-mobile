import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/katalog.dart';
import 'katalog_edit_page.dart';
import 'katalog_delete_page.dart';

class KatalogDetailPage extends StatelessWidget {
  final int productId;
  const KatalogDetailPage({super.key, required this.productId});

  Future<Katalog> fetchDetail() async {
    final res =
        await http.get(Uri.parse('https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/katalog/json/'));
    return katalogFromJson(res.body)
        .firstWhere((e) => e.id == productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: FutureBuilder<Katalog>(
        future: fetchDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Produk tidak ditemukan'));
          }
          final p = snapshot.data!;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.network(
                          p.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(p.category,
                              style:
                                  const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 12),
                          Text(
                            'Rp ${p.price}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Text(p.description),
                          const SizedBox(height: 12),
                          Text(
                            'Stok: ${p.stock} | Rating: ${p.rating} / 5',
                            style:
                                const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          KatalogEditPage(product: p),
                                    ),
                                  );
                                },
                                child: const Text('Edit'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () async {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (_) =>
                                        KatalogDeletePage(
                                            productId: p.id),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
