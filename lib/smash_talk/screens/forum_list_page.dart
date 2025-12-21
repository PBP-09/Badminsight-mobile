import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/smash_talk/models/SmashTalk.dart'; 
import 'package:badminsights_mobile/smash_talk/screens/post_forum.dart'; 
import 'package:badminsights_mobile/smash_talk/screens/post_detail_page.dart'; 
import 'package:intl/intl.dart'; 
import 'package:badminsights_mobile/left_drawer.dart'; 

class ForumListPage extends StatefulWidget {
  const ForumListPage({super.key});

  @override
  State<ForumListPage> createState() => _ForumListPageState();
}

class _ForumListPageState extends State<ForumListPage> {
  // Variabel untuk Search dan Filter
  
  String _searchQuery = "";
  String _selectedCategory = ""; // Kosong artinya "Semua"
  final TextEditingController _searchController = TextEditingController();

  // Mapping nama tampilan ke value API (sesuai models.py Django)
  final Map<String, String> categoryMap = {
    "Semua": "",
    "Pertanyaan": "question",
    "Pengalaman": "experience",
    "Rekomendasi": "recommendation",
    "Strategi": "strategy",
    "Pemain": "player",
    "Pertandingan": "match",
    "Umum": "general",
  };

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      drawer: const LeftDrawer(), 
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Smash Talk", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      
      // === PERBAIKAN: FloatingActionButton ditaruh DI DALAM Scaffold ===
      floatingActionButton: request.loggedIn 
          ? FloatingActionButton.extended(
              onPressed: () async {
                // Refresh halaman setelah buat post
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostFormPage()),
                );
                setState(() {}); 
              },
              backgroundColor: const Color(0xFF2563EB),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Buat Postingan", style: TextStyle(color: Colors.white)),
            )
          : null, // Kalau belum login, tombol hilang (null)
      // ================================================================

      body: Column(
        children: [
          // === 1. SEARCH BAR ===
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari postingan...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = "");
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              onSubmitted: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // === 2. KATEGORI FILTER (Horizontal Scroll) ===
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categoryMap.keys.length,
              separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                String label = categoryMap.keys.elementAt(index);
                String value = categoryMap[label]!;
                bool isSelected = _selectedCategory == value;

                return ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  selectedColor: const Color(0xFF2563EB),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: Colors.grey.shade100,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedCategory = selected ? value : "";
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // === 3. DAFTAR POSTINGAN ===
          Expanded(
            child: FutureBuilder(
              future: request.get(
                'http://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/json/?q=$_searchQuery&category=$_selectedCategory'
              ),
              builder: (context, AsyncSnapshot snapshot) {
                // 1. Cek Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // 2. Cek Data Null
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("Tidak ada data."));
                } 

                // 3. Ambil List Data
                var data = snapshot.data;
                if (data is Map && data.containsKey('results')) {
                   data = data['results'];
                }

                // 4. Cek Data Kosong
                if (data.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("Tidak ada postingan ditemukan.", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                // === 5. LIST VIEW DENGAN CARD ANIMASI (INKWELL) ===
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    var post = SmashTalk.fromJson(data[index]);
                    
                    // LANGSUNG PANGGIL WIDGETNYA
                    return _buildPostCard(post); 
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(SmashTalk post) {
    String formattedDate = DateFormat('dd MMM yyyy HH:mm').format(post.createdAt);

    // GUNAKAN CARD + INKWELL UNTUK EFEK PENCET (RIPPLE)
    return Card(
      elevation: 2, // Memberi bayangan sedikit biar timbul
      margin: EdgeInsets.zero, // Reset margin karena sudah diatur di ListView
      clipBehavior: Clip.antiAlias, // Biar efek pencetnya gak keluar dari sudut bulat
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Sudut membulat
      ),
      child: InkWell(
        // EFEK ANIMASI PENCET ADA DI SINI
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(postId: post.id),
            ),
          ).then((_) => setState((){}));
        },
        // Warna cipratan saat ditekan (opsional)
        splashColor: Colors.blue.withOpacity(0.1), 
        highlightColor: Colors.blue.withOpacity(0.05),
        
        child: Padding(
          padding: const EdgeInsets.all(16), // Padding pindah ke dalam InkWell
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      post.category.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(post.author, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                  const Text(" • ", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Expanded(
                    child: Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis),
                  ),
                  const Icon(Icons.thumb_up_alt_rounded, size: 14, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 4),
                  Text("${post.likeCount}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  const Icon(Icons.visibility, size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text("${post.views}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
              ),
              const SizedBox(height: 8),
              Text(
                post.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF4B5563), fontSize: 14, height: 1.5),
              ),
              if (post.image != null && post.image!.isNotEmpty) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Builder(builder: (context) {
                    String imgUrl = post.image!.replaceAll('10.0.2.2', '127.0.0.1');
                    return Image.network(
                      imgUrl, 
                      height: 150, 
                      width: double.infinity, 
                      fit: BoxFit.cover, 
                      errorBuilder: (ctx, err, stack) => const SizedBox()
                    );
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}