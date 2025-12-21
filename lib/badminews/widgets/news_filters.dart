import 'package:flutter/material.dart';

class NewsFilters extends StatefulWidget {
  final Function(String?) onCategoryChanged;
  final Function(String?) onSearchChanged;
  final Function(String) onSortChanged;

  const NewsFilters({
    super.key,
    required this.onCategoryChanged,
    required this.onSearchChanged,
    required this.onSortChanged,
  });

  @override
  State<NewsFilters> createState() => _NewsFiltersState();
}

class _NewsFiltersState extends State<NewsFilters> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String _sortBy = 'date';

  final List<String> _categories = [
    'general',
    'tournament',
    'player',
    'other',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search news...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              widget.onSearchChanged(value.isEmpty ? null : value);
            },
          ),
          const SizedBox(height: 16),

          // Filters Row
          Row(
            children: [
              // Category Dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ..._categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category[0].toUpperCase() + category.substring(1)),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                    widget.onCategoryChanged(value);
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Sort Dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _sortBy,
                  decoration: InputDecoration(
                    labelText: 'Sort by',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'date',
                      child: Text('Date'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'upvotes',
                      child: Text('Upvotes'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortBy = value;
                      });
                      widget.onSortChanged(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}