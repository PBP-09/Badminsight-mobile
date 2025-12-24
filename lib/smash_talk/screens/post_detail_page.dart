import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/smash_talk/models/SmashTalk.dart';
class PostDetailPage extends StatefulWidget {
  final int postId;
  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  Future<Map<String, dynamic>> fetchPostDetail(CookieRequest request) async {
    final response = await request.get('https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/json/${widget.postId}/');
    return response;
  }

  Future<List<dynamic>> fetchComments(CookieRequest request) async {
    final response = await request.get('https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/get-comments-flutter/${widget.postId}/');
    return response['comments'];
  }

  Future<void> sendComment(CookieRequest request) async {
    if (_commentController.text.trim().isEmpty) return;
    final response = await request.post(
      'https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/add-comment-flutter/${widget.postId}/',
      {'content': _commentController.text},
    );
    if (response['status'] == 'success') {
      _commentController.clear();
      FocusScope.of(context).unfocus();
      setState(() {}); 
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Komentar terkirim!")));
    }
  }

  Future<void> toggleLike(CookieRequest request) async {
  // === CEK LOGIN ===
  if (!request.loggedIn) {
    // Kalau belum login, munculin pesan peringatan
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan login terlebih dahulu untuk menyukai postingan ini!"),
          backgroundColor: Colors.orangeAccent, // Warna biar keliatan kayak peringatan
          behavior: SnackBarBehavior.floating, // Biar melayang lebih modern
          duration: Duration(seconds: 2),
        ),
      );
    }
    return; // Berhenti di sini, nggak lanjut nembak API
  }

  // Jika sudah login, lanjut tembak API Like
  final response = await request.post(
    'https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/toggle-like-flutter/${widget.postId}/',
    {},
  );
  
  if (response['status'] == 'success') {
    setState(() {}); // Refresh UI biar jumlah like berubah
  }
}

  Future<void> deletePost(CookieRequest request) async {
    final response = await request.post('https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/delete-post-flutter/${widget.postId}/', {});
    if (context.mounted && response['status'] == 'success') {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Postingan dihapus!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text("Postingan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // === BACKGROUND: GRADASI SPORTY BLUE ===
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFFF1F5F9)], // Biru navy ke biru lapangan
            stops: [0.0, 0.3, 0.7],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchPostDetail(request),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            if (snapshot.hasError || !snapshot.hasData) return const Center(child: Text("Gagal memuat data."));

            final post = SmashTalk.fromJson(snapshot.data!);

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 60,
                left: 14, right: 14, bottom: 100
              ),
              child: Column(
                children: [
                  // === KARTU POSTINGAN UTAMA ===
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Profil
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFF2563EB),
                                child: Text(post.author[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(post.category, style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Spacer(),
                              // Tombol Titik Tiga / Hapus
                              if (request.jsonData['username'] == post.author)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () => deletePost(request),
                                ),
                            ],
                          ),
                        ),

                        // === GAMBAR UTAMA (Dikasih batas tinggi biar gak raksasa) ===
                        if (post.image != null && post.image!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                constraints: const BoxConstraints(maxHeight: 400), // <--- BIAR GAK KELUAR LAYAR
                                width: double.infinity,
                                child: Image.network(
                                  // LOGIKA REPLACE LO TETEP DISINI
                                  post.image!.replaceFirst('https://rousan-chandra-badminsights.pbp.cs.ui.ac.id', 'http://localhost:8000')
                                             .replaceFirst('http://10.0.2.2:8000', 'http://localhost:8000'),
                                  fit: BoxFit.cover, // <--- Cover biar rapi di dalem box
                                  errorBuilder: (ctx, err, stack) => Container(
                                    height: 150, color: Colors.grey[200], child: const Icon(Icons.broken_image, size: 50)
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Action Bar (Action Icons)
                                        Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => toggleLike(request), // <--- Pastiin manggil fungsi ini
                        icon: Icon(
                          post.likeCount > 0 ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                          color: post.likeCount > 0 ? Colors.blue : Colors.black87,
                          size: 24,
                        ),
                      ),

                      // ICON KOMENTAR (Balon Teks)
                      IconButton(
                        onPressed: () {
                          if (!request.loggedIn) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login dulu bos kalau mau komen!"),
                                backgroundColor: Colors.orangeAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            // Kalau udah login, otomatis fokus ke kotak ketik di bawah
                            FocusScope.of(context).requestFocus(FocusNode()); 
                          }
                        },
                        icon: const Icon(Icons.mode_comment_outlined, size: 26, color: Colors.black87),
                      ),

                      // ICON SEND (Pesawat Kertas)
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Fitur bagikan akan segera hadir!"))
                          );
                        },
                        icon: const Icon(Icons.send_outlined, size: 26),
                      ),

                      const Spacer(), 
                
                    ],
                  ),
                ),

                        // Like Count & Caption
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text("${post.likeCount} suka", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(post.content, style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // === BAGIAN KOMENTAR (Card Terpisah biar estetik) ===
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10), // Jarak dikit dari card postingan
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.blue),
                            const SizedBox(width: 8),
                            const Text("Komentar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 12), // Jarak kecil ke komen pertama
                        FutureBuilder<List<dynamic>>(
                          future: fetchComments(request),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const LinearProgressIndicator(color: Colors.blue, minHeight: 2);
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text("Belum ada komentar. Jadilah yang pertama!", 
                                style: TextStyle(color: Colors.grey, fontSize: 13));
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero, // Biar nggak ada padding bawaan list
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10), // Jarak antar komen
                              itemBuilder: (context, index) {
                                final comment = snapshot.data![index];
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 12, 
                                      backgroundColor: Colors.blue.shade50,
                                      child: Text(comment['author'][0].toUpperCase(), 
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(color: Colors.black, fontSize: 13),
                                          children: [
                                            TextSpan(text: "${comment['author']} ", 
                                              style: const TextStyle(fontWeight: FontWeight.bold)),
                                            TextSpan(text: comment['content']),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet: request.loggedIn ? Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10, left: 16, right: 8, top: 10),
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
        child: Row(
          children: [
            Expanded(child: TextField(controller: _commentController, decoration: const InputDecoration(hintText: "Tambah komentar...", border: InputBorder.none))),
            TextButton(onPressed: () => sendComment(request), child: const Text("Kirim", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
          ],
        ),
      ) : null,
    );
  }
}