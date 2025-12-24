import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({super.key});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";
  String _selectedCategory = "general";
  XFile? _imageFile;
  String _imageName = "Belum ada file dipilih";

  final Map<String, String> _categories = {
    "Umum": "general",
    "Pertanyaan": "question",
    "Pengalaman": "experience",
    "Rekomendasi": "recommendation",
    "Strategi": "strategy",
    "Pemain": "player",
    "Pertandingan": "match",
  };

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
        _imageName = image.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Buat Postingan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // === BACKGROUND THEME SINKRON ===
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFFF1F5F9)],
            stops: [0.0, 0.2, 0.5],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 60,
            left: 16, right: 16, bottom: 40,
          ),
          child: Column(
            children: [
              // === KARTU FORM UTAMA ===
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 8))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.edit_note_rounded, color: Color(0xFF2563EB), size: 28),
                            SizedBox(width: 10),
                            Text("Postingan Baru", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- JUDUL ---
                        _buildLabel("Judul Postingan"),
                        TextFormField(
                          style: const TextStyle(fontSize: 15),
                          decoration: _inputStyle("Masukkan judul yang menarik..."),
                          onChanged: (value) => _title = value,
                          validator: (value) => value!.isEmpty ? "Judul gak boleh kosong bro!" : null,
                        ),
                        const SizedBox(height: 20),

                        // --- KATEGORI ---
                        _buildLabel("Kategori"),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: _inputStyle(""),
                          items: _categories.entries.map((e) => DropdownMenuItem(value: e.value, child: Text(e.key))).toList(),
                          onChanged: (val) => setState(() => _selectedCategory = val!),
                        ),
                        const SizedBox(height: 20),

                        // --- KONTEN ---
                        _buildLabel("Isi Konten"),
                        TextFormField(
                          maxLines: 5,
                          style: const TextStyle(fontSize: 14),
                          decoration: _inputStyle("Apa yang mau lo bahas hari ini?"),
                          onChanged: (value) => _content = value,
                          validator: (value) => value!.isEmpty ? "Isi kontennya dulu dong!" : null,
                        ),
                        const SizedBox(height: 20),

                        // --- GAMBAR ---
                        _buildLabel("Gambar (Opsional)"),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.image_search, size: 18),
                                label: const Text("Pilih File"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(_imageName, style: const TextStyle(fontSize: 12, color: Colors.blueGrey), overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),

                        // --- TOMBOL AKSI ---
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 5,
                                  shadowColor: const Color(0xFF2563EB).withOpacity(0.4),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    String? base64Image;
                                    if (_imageFile != null) {
                                      Uint8List bytes = await _imageFile!.readAsBytes();
                                      base64Image = base64Encode(bytes);
                                    }
                                    final response = await request.post(
                                      "https://rousan-chandra-badminsights.pbp.cs.ui.ac.id/forum/create-post-flutter/",
                                      {
                                        'title': _title,
                                        'content': _content,
                                        'category': _selectedCategory,
                                        'image': base64Image ?? "",
                                      },
                                    );
                                    if (context.mounted && response['status'] == 'success') {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Postingan Terkirim!")));
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: const Text("Buat Postingan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 14)),
    );
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
    );
  }
}