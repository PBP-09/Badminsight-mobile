import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:badminsights_mobile/authentication/auth_state.dart';
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
    'racket',
    'shuttlecock',
    'jersey',
    'shoes',
    'accessories',
  ];

  Future<void> fetchProducts() async {
    final res = await http.get(
      Uri.parse('https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/katalog/json/'),
    );
    final data = katalogFromJson(res.body);
    setState(() {
      allProducts = data;
      applyFilter();
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
  Widget build(BuildContext context) {
    final isAdmin = AuthState.isAdmin;

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 900;
    final crossAxisCount = isMobile ? 1 : isTablet ? 2 : 4;

    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(title: const Text('Katalog Merch')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (isMobile)
              Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari produk...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    isDense: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
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
                  const SizedBox(height: 8),

                  if (isAdmin)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const KatalogEditPage(),
                            ),
                          );
                          if (result == true) fetchProducts();
                        },
                        child: const Text('+ Tambah Produk'),
                      ),
                    ),
                ],
              )
            else
              Row(
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

                  if (isAdmin)
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KatalogEditPage(),
                          ),
                        );
                        if (result == true) fetchProducts();
                      },
                      child: const Text('+ Tambah Produk'),
                    ),
                ],
              ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: isMobile ? 0.92 : 0.72,
                  crossAxisSpacing: isMobile ? 8 : 12,
                  mainAxisSpacing: isMobile ? 8 : 12,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (c, i) => ProductCard(
                  product: filteredProducts[i],
                  onRefresh: fetchProducts,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
