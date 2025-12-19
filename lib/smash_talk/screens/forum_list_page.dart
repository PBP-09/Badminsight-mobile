import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:badminsights_mobile/smash_talk/models/post.dart';

class ForumListPage extends StatelessWidget {
  const ForumListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text("Smash Talk Forum")),
      body: FutureBuilder(
        future: request.get('http://10.0.2.2:8000/forum/json/'), // Sesuai root urls.py lu
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Text("Gak ada postingan.");
            } else {
              // results sesuai dengan return JsonResponse di api_post_list
              var data = snapshot.data['results'];
              List<Post> listPost = [];
              for (var d in data) {
                listPost.add(Post.fromJson(d));
              }
              // Pakai ListView.builder buat nampilin Card yang rapi
              return ListView.builder(
                itemCount: snapshot.data['results'].length,
                itemBuilder: (_, index) {
                  var post = snapshot.data['results'][index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kalau ada gambar, tampilin gambarnya
                        if (post['image'] != null)
                          Image.network(post['image'], fit: BoxFit.cover, width: double.infinity, height: 200),
                        
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(post['content'], maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("👤 ${post['author']}", style: const TextStyle(color: Colors.grey)),
                                  Row(
                                    children: [
                                      const Icon(Icons.favorite, color: Colors.red, size: 16),
                                      Text(" ${post['like_count']}"),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.visibility, color: Colors.blue, size: 16),
                                      Text(" ${post['views']}"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}