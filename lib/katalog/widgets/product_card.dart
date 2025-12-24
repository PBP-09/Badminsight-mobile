import 'package:flutter/material.dart';
import '../models/katalog.dart';
import '../screens/katalog_detail_page.dart';
import '../screens/katalog_edit_page.dart';
import '../screens/katalog_delete_page.dart';

class ProductCard extends StatelessWidget {
  final Katalog product;
  final VoidCallback onRefresh;

  const ProductCard({
    super.key,
    required this.product,
    required this.onRefresh,
  });

  String categoryLabel(String c) {
    switch (c) {
      case 'racket':
        return 'Raket';
      case 'shuttlecock':
        return 'Shuttlecock';
      case 'jersey':
        return 'Jersey';
      case 'shoes':
        return 'Sepatu';
      case 'accessories':
        return 'Aksesoris';
      default:
        return c;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  product.imageUrl.isNotEmpty
                      ? product.imageUrl
                      : 'https://via.placeholder.com/400x300',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                KatalogEditPage(product: product),
                          ),
                        );

                        if (result == true) {
                          onRefresh();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (_) =>
                              KatalogDeletePage(productId: product.id),
                        );
                        
                        if (result == true) {
                          onRefresh();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  categoryLabel(product.category),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${product.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                product.rating > 0
                    ? Text('Rating: ${product.rating.toStringAsFixed(1)} / 5')
                    : const Text(
                        'Belum ada rating',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              KatalogDetailPage(productId: product.id),
                        ),
                      );
                    },
                    child: const Text('Lihat Detail'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
