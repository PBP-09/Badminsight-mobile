import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/authentication/auth_state.dart';
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
    // ⛔ JANGAN PAKAI loggedIn UNTUK ADMIN
    final isAdmin = AuthState.isAdmin;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    product.imageUrl.isNotEmpty ? product.imageUrl : 'invalid',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image_not_supported,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'No Image',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              if (isAdmin)
                Positioned(
                  top: 6,
                  right: 6,
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
                          if (result == true) onRefresh();
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
                          if (result == true) onRefresh();
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(categoryLabel(product.category),
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text('Rp ${product.price}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
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
