import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class KatalogDeletePage extends StatelessWidget {
  final int productId;
  const KatalogDeletePage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    Future<void> deleteProduct() async {
      final response = await request.post(
        'https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/katalog/api/delete/$productId/',
        {},
      );

      if (response == null || response['success'] != true) {
        throw Exception('Gagal menghapus produk');
      }
    }

    return AlertDialog(
      title: const Text('Hapus Produk'),
      content: const Text('Anda yakin ingin menghapus produk ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              await deleteProduct();
              if (context.mounted) {
                Navigator.pop(context, true); // signal sukses
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menghapus produk')),
                );
              }
            }
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}

