import 'package:flutter/material.dart';
import 'package:badminsights_mobile/widgets/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<ItemHomepage> items = [
    ItemHomepage("Who's on Court?", Icons.person, const Color(0xFF1E3A8A)),
    ItemHomepage("SmashTalk", Icons.message, const Color(0xFF0D9488)),
    ItemHomepage("BadmiNews", Icons.newspaper, const Color(0xFFB45309)),
    ItemHomepage("Merch", Icons.shop, const Color(0xFFBE123C)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), 
      appBar: AppBar(
        title: const Text(
          'Badminsights',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E3A8A), 
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Section (All Things Badminton)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'All Things Badminton, in One Place.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover player bios, explore merch, and join discussions worldwide.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24.0),

              Wrap(
                spacing: 12.0, 
                runSpacing: 12.0, 
                alignment: WrapAlignment.center,
                children: items.map((ItemHomepage item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.6,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Text(content, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(8), 
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("Membuka ${item.name}...")));
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