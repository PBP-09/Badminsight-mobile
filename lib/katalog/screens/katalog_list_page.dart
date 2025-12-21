import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/katalog.dart';
import '../widgets/product_card.dart';
import 'katalog_edit_page.dart';
import 'package:badminsights_mobile/left_drawer.dart'; 

class KatalogListPage extends StatefulWidget {
  const KatalogListPage({super.key});

  @override
  State<KatalogListPage> createState() => _KatalogListPageState();
}

class _KatalogListPageState extends State<KatalogListPage> {
  List<Katalog> allProducts = [];
  List<Katalog> filteredProducts = [];

  final TextEditingController searchController = TextEditingController();
  String selectedCategory = '';

  final categories = [
    '',
    'Racket',
    'Shuttlecock',
    'Jersey',
    'Shoes',
    'Accessories',
  ];

  Future<void> fetchProducts() async {
    final res = await http.get(
      Uri.parse('http://rousan-chandra-badminsights.pbp.cs.ui.ac.id:8000/katalog/json/'),
    );
    final data = katalogFromJson(res.body);
    setState(() {
      allProducts = data;
      filteredProducts = data;
    });
  }

  void applyFilter() {
    final q = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = allProducts.where((p) {
        final matchQuery =
            p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q);
        final matchCategory =
            selectedCategory.isEmpty || p.category == selectedCategory;
        return matchQuery && matchCategory;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(applyFilter);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(), 
      appBar: AppBar(title: const Text('Katalog Merch')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cari produk...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: selectedCategory,
                      items: categories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c.isEmpty ? 'Semua Kategori' : c,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        selectedCategory = v!;
                        applyFilter();
                      },
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KatalogEditPage(),
                          ),
                        );
                        if (result == true) {
                          await fetchProducts();
                        }
                      },
                      child: const Text('+ Tambah Produk'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (c, i) =>
                      ProductCard(product: filteredProducts[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
