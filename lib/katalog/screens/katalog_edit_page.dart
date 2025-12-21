import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/katalog.dart';

class KatalogEditPage extends StatefulWidget {
  final Katalog? product;
  const KatalogEditPage({super.key, this.product});

  @override
  State<KatalogEditPage> createState() => _KatalogEditPageState();
}

class _KatalogEditPageState extends State<KatalogEditPage> {
  late TextEditingController name;
  late TextEditingController price;
  late TextEditingController stock;
  late TextEditingController image;
  late TextEditingController desc;
  late TextEditingController rating;

  String category = 'racket';

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.product?.name ?? '');
    price = TextEditingController(text: widget.product?.price.toString() ?? '0');
    stock = TextEditingController(text: widget.product?.stock.toString() ?? '0');
    image = TextEditingController(text: widget.product?.imageUrl ?? '');
    desc = TextEditingController(text: widget.product?.description ?? '');
    rating = TextEditingController(text: widget.product?.rating.toString() ?? '0');
    category = widget.product?.category ?? 'racket';
  }

  Future<void> submit() async {
    final request = context.read<CookieRequest>();

    final url = widget.product == null
        ? 'http://127.0.0.1:8000/katalog/create/'
        : 'http://127.0.0.1:8000/katalog/${widget.product!.id}/edit/';

    final response = await request.post(url, {
      'name': name.text.trim(),
      'category': category,
      'price': price.text,
      'stock': stock.text,
      'image_url': image.text.trim(),
      'description': desc.text.trim(),
      'rating': rating.text.isEmpty ? '0' : rating.text,
    });

    if (response == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan produk')),
        );
      }
      return;
    }

    if (context.mounted) Navigator.pop(context, true);
  }

  InputDecoration field(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Tambah Produk' : 'Edit Produk'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(controller: name, decoration: field('Nama')),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: field('Kategori'),
                      items: const [
                        DropdownMenuItem(value: 'racket', child: Text('Raket')),
                        DropdownMenuItem(value: 'shuttlecock', child: Text('Shuttlecock')),
                        DropdownMenuItem(value: 'jersey', child: Text('Jersey')),
                        DropdownMenuItem(value: 'shoes', child: Text('Sepatu')),
                        DropdownMenuItem(value: 'accessories', child: Text('Aksesoris')),
                      ],
                      onChanged: (v) => setState(() => category = v!),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: price,
                      decoration: field('Harga'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: stock,
                      decoration: field('Stok'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: image,
                      decoration: field('URL Gambar'),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: desc,
                      decoration: field('Deskripsi'),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: rating,
                      decoration: field('Rating (0–5)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: const Text('Simpan'),
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
