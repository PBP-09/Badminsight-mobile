import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/smash_talk/models/SmashTalk.dart';
import 'package:intl/intl.dart';
import 'package:badminsights_mobile/authentication/login.dart'; // Import Login Page buat redirect

class PostDetailPage extends StatefulWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  Future<Map<String, dynamic>> fetchPostDetail(CookieRequest request) async {
    // Gunakan 127.0.0.1 untuk Chrome
    final response = await request.get('http://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/json/${widget.postId}/');
    return response;
  }

  Future<List<dynamic>> fetchComments(CookieRequest request) async {
    final response = await request.get('http://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/get-comments-flutter/${widget.postId}/');
    return response['comments'];
  }

  Future<void> sendComment(CookieRequest request) async {
    if (_commentController.text.isEmpty) return;

    final response = await request.post(
      'http://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/add-comment-flutter/${widget.postId}/',
      {'content': _commentController.text},
    );

    if (response['status'] == 'success') {
      _commentController.clear();
      setState(() {}); 
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Komentar terkirim!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal mengirim komentar.")));
    }
  }

  Future<void> toggleLike(CookieRequest request) async {
    // Mencegah Guest melakukan Like
    if (!request.loggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login dulu untuk menyukai postingan!")));
      return;
    }

    final response = await request.post(
      'http://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/toggle-like-flutter/${widget.postId}/',
      {},
    );
    if (response['status'] == 'success') {
      setState(() {}); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: const Text("Detail Postingan")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPostDetail(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Gagal memuat data."));
          }

          final post = SmashTalk.fromJson(snapshot.data!);
          final int commentCount = snapshot.data!['comment_count'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === BAGIAN 1: KARTU POSTINGAN ===
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(post.category, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Text("Oleh ${post.author}", style: const TextStyle(color: Colors.grey)),
                          const Text(" • ", style: TextStyle(color: Colors.grey)),
                          Text(DateFormat('dd MMM yyyy HH:mm').format(post.createdAt), style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(post.content, style: const TextStyle(fontSize: 16, height: 1.5)),
                      const SizedBox(height: 16),
                      if (post.image != null && post.image!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            post.image!.replaceAll('10.0.2.2', '127.0.0.1'),
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => const SizedBox(),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => toggleLike(request),
                            icon: const Icon(Icons.favorite, size: 16),
                            label: Text("Like (${post.likeCount})"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade50,
                              foregroundColor: Colors.pink,
                              elevation: 0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),

                // === BAGIAN 2: STATISTIK ===
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Statistik", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("Like: ${post.likeCount}"),
                      Text("Komentar: $commentCount"),
                      Text("Dilihat: ${post.views}"),
                      Text("Dibuat: ${DateFormat('dd MMM yyyy').format(post.createdAt)}"),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text("Komentar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // === BAGIAN 3: INPUT KOMENTAR (LOGIC GUEST vs USER) ===
                if (request.loggedIn) ...[
                  // TAMPILAN UNTUK USER LOGIN: Form Input
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: "Tulis komentar...",
                            border: InputBorder.none,
                          ),
                          maxLines: 3,
                        ),
                        const Divider(),
                        ElevatedButton(
                          onPressed: () => sendComment(request),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                          child: const Text("Kirim Komentar", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // TAMPILAN UNTUK GUEST: Pesan Suruh Login
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200, 
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.lock_outline, color: Colors.grey, size: 40),
                        const SizedBox(height: 8),
                        const Text(
                          "Silakan login untuk mengirim komentar.",
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {
                             Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                          },
                          child: const Text("Login Sekarang"),
                        )
                      ],
                    ),
                  ),
                ],
                // =======================================================

                const SizedBox(height: 16),

                // === BAGIAN 4: DAFTAR KOMENTAR ===
                FutureBuilder<List<dynamic>>(
                  future: fetchComments(request),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("Belum ada komentar.")));
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final comment = snapshot.data![index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(comment['author'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(
                                    DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(comment['created_at'])),
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(comment['content']),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}