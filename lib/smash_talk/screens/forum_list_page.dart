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
  String _searchQuery = "";
  String _selectedCategory = "";
  final TextEditingController _searchController = TextEditingController();

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
      extendBodyBehindAppBar: true, // Biar gradient background tembus ke atas
      appBar: AppBar(
        title: const Text("Smash Talk", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent, // AppBar transparan biar liat gradient
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      floatingActionButton: request.loggedIn 
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const PostFormPage()));
                setState(() {}); 
              },
              backgroundColor: const Color(0xFF2563EB),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Buat Postingan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        // === BACKGROUND THEME: Sporty Gradient ===
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFFF1F5F9)],
            stops: [0.0, 0.2, 0.5],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 50), // Spasi AppBar
            
            // === 1. SEARCH BAR (Modern Style) ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Cari postingan smash...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
                onSubmitted: (value) => setState(() => _searchQuery = value),
              ),
            ),


            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categoryMap.keys.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  String label = categoryMap.keys.elementAt(index);
                  String value = categoryMap[label]!;
                  bool isSelected = _selectedCategory == value;

                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) => setState(() => _selectedCategory = selected ? value : ""),

                    // WARNA BACKGROUND
                    selectedColor: const Color(0xFF2563EB), // Biru saat dipilih
                    backgroundColor: Colors.white,           // Putih solid saat tidak dipilih

                    // WARNA TEKS (Ini kuncinya biar kelihatan)
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87, // Putih kalo dipilih, Hitam kalo nggak
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),

                    // STYLING TAMBAHAN
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : Colors.grey.shade300, // Kasih garis tipis kalo gak dipilih
                      ),
                    ),
                    elevation: 2, // Kasih shadow dikit biar nongol
                    pressElevation: 4,
                  );
                },
              ),
            ),

            // === 3. LIST POSTINGAN (Cards) ===
            Expanded(
              child: FutureBuilder(
                future: request.get('https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/json/?q=$_searchQuery&category=$_selectedCategory'),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.white));
                  if (!snapshot.hasData) return const Center(child: Text("Gagal memuat data", style: TextStyle(color: Colors.white)));

                  var data = snapshot.data;
                  if (data is Map && data.containsKey('results')) data = data['results'];
                  // === 4. CEK DATA KOSONG (Empty State - Fix Visibility) ===
                  if (data.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon dibikin Biru Navy transparan biar estetik
                            Icon(
                              Icons.forum_outlined, // Pake icon forum biar lebih nyambung
                              size: 100, 
                              color: const Color(0xFF1E3A8A).withOpacity(0.15), 
                            ),
                            const SizedBox(height: 20),
                            // Judul pake Biru Navy Gelap biar JELAS KELIATAN
                            const Text(
                              "Belum ada postingan",
                              style: TextStyle(
                                color: Color(0xFF1E3A8A), // Biru Navy
                                fontSize: 22, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Deskripsi pake abu-abu slate biar kebaca
                            Text(
                              _selectedCategory == "" 
                                  ? "Ayo mulai diskusi! Jadilah orang pertama yang bikin postingan di Smash Talk." 
                                  : "Sepertinya belum ada yang bahas '${categoryMap.keys.firstWhere((k) => categoryMap[k] == _selectedCategory)}' nih.",
                              style: const TextStyle(
                                color: Color(0xFF64748B), // Abu-abu Slate
                                fontSize: 14,
                                height: 1.5
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            // Opsional: Tambah panah kecil nunjuk ke tombol tambah
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 80),
                    itemCount: data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) => _buildPostCard(SmashTalk.fromJson(data[index])),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(SmashTalk post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailPage(postId: post.id))).then((_) => setState(() {})),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Profil & Kategori
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue.shade800,
                        child: Text(post.author[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(post.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const Text("•", style: TextStyle(color: Colors.grey)),
                            Text(post.category.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Text(DateFormat('dd MMM').format(post.createdAt), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),

                // Judul & Isi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(post.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text(post.content, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),

                // Preview Gambar (Disesuaikan untuk PWS)
                if (post.image != null && post.image!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        // LOGIC SAKTI UNTUK PWS:
                        // 1. Ganti semua localhost/127.0.0.1/10.0.2.2 jadi domain PWS lo
                        // 2. Pastikan protokolnya HTTPS
                        post.image!
                            .replaceAll('http://localhost:8000', 'https://rousan-chandra-badminsights.pbp.cs.ui.ac.id')
                            .replaceAll('http://127.0.0.1:8000', 'https://rousan-chandra-badminsights.pbp.cs.ui.ac.id')
                            .replaceAll('http://10.0.2.2:8000', 'https://rousan-chandra-badminsights.pbp.cs.ui.ac.id')
                            .replaceFirst('http://', 'https://'), // Paksa HTTPS
                        height: 150, 
                        width: double.infinity, 
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          height: 50, 
                          color: Colors.grey[100], 
                          child: const Icon(Icons.broken_image, color: Colors.grey)
                        ),
                      ),
                    ),
                  ),

                // Footer (Action Icons)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 16, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.thumb_up_alt_rounded, size: 18, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text("${post.likeCount}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      const Icon(Icons.mode_comment_outlined, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${post.views}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Icon(Icons.send_outlined, size: 18, color: Colors.grey),
                      const SizedBox(width: 12),
                      const Icon(Icons.bookmark_border_rounded, size: 20, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}