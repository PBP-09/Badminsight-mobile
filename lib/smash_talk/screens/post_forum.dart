import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({super.key});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";
  String _category = "DISKUSI"; // Default sesuai Choice di Django

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Postingan Baru')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Judul"),
                onChanged: (String? value) => setState(() => _title = value!),
                validator: (value) => value!.isEmpty ? "Judul tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(hintText: "Isi Postingan"),
                maxLines: 3,
                onChanged: (String? value) => setState(() => _content = value!),
                validator: (value) => value!.isEmpty ? "Isi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Tembak ke path 'create-post-flutter/' di bawah 'forum/'
                    final response = await request.post(
                      "http://localhost:8000/forum/create-post-flutter/",
                      {
                        'title': _title,
                        'content': _content,
                        'category': _category,
                      },
                    );

                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil posting!")));
                        Navigator.pop(context); // Kembali ke list
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal posting.")));
                      }
                    }
                  }
                },
                child: const Text("Kirim"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}