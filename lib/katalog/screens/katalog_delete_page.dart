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
      await request.post(
        'http://127.0.0.1:8000/katalog/$productId/delete/',
        {},
      );
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
            await deleteProduct();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
