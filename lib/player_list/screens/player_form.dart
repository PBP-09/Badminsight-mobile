import 'package:badminsights_mobile/player_list/screens/player_entry_list.dart';
import 'package:flutter/material.dart';
import 'package:badminsights_mobile/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
class PlayerFormPage extends StatefulWidget {
  const PlayerFormPage({super.key});

  @override
  State<PlayerFormPage> createState() => _PlayerFormPageState();
}

class _PlayerFormPageState extends State<PlayerFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  String _name = "";
  String _country = "";
  int _rank = 0;
  String _status = "Active";
  DateTime _birthDate = DateTime(2000, 1, 1);
  String _biography = "";

  final TextEditingController _dateController = TextEditingController();

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF1E3A8A)),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // bg-surface
      appBar: AppBar(
        title: const Text(
          'Add New Player',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Masukkan Detail Pemain",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Lengkapi data profil pemain sesuai form di bawah ini.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // --- FIELD NAMA ---
              _buildLabel("Nama Lengkap"),
              TextFormField(
                decoration: _inputDecoration("Contoh: Viktor Axelsen", Icons.person),
                onChanged: (value) => _name = value,
                validator: (value) => value == null || value.isEmpty ? "Nama wajib diisi" : null,
              ),

              const SizedBox(height: 20),

              // --- FIELD NEGARA ---
              _buildLabel("Asal Negara"),
              TextFormField(
                decoration: _inputDecoration("Contoh: Denmark", Icons.flag),
                onChanged: (value) => _country = value,
                validator: (value) => value == null || value.isEmpty ? "Negara wajib diisi" : null,
              ),

              const SizedBox(height: 20),

              // --- FIELD RANK ---
              _buildLabel("World Rank"),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Masukkan angka ranking", Icons.leaderboard),
                onChanged: (value) => _rank = int.tryParse(value) ?? 0,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Ranking wajib diisi";
                  if (int.tryParse(value) == null) return "Harus berupa angka";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // --- FIELD STATUS (DROPDOWN) ---
              _buildLabel("Status Pemain"),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: _inputDecoration("", Icons.info_outline),
                items: ["Active", "Retired", "Injured"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),

              const SizedBox(height: 20),

              // --- FIELD TANGGAL LAHIR (DATE PICKER) ---
              _buildLabel("Tanggal Lahir"),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: _inputDecoration("Pilih tanggal lahir", Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthDate = pickedDate;
                      _dateController.text = 
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty ? "Tanggal lahir wajib diisi" : null,
              ),

              const SizedBox(height: 20),

              // --- FIELD BIOGRAFI (MULTILINE) ---
              _buildLabel("Biografi Singkat"),
              TextFormField(
                maxLines: 4,
                decoration: _inputDecoration("Ceritakan singkat karir pemain...", Icons.article_outlined),
                onChanged: (value) => _biography = value,
                validator: (value) => value == null || value.isEmpty ? "Biografi wajib diisi" : null,
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB45309), // Warna aksen (Amber)
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                     onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Mengirim data ke Django menggunakan request.postJson
                        final response = await request.postJson(
                          "http://rousan-chandra-badminsights.pbp.cs.ui.ac.id/create-player-flutter/", // Sesuaikan URL dengan Django kamu
                          jsonEncode(<String, dynamic>{
                            "name": _name,
                            "date_of_birth": _birthDate.toIso8601String().split('T')[0], // Format YYYY-MM-DD
                            "country": _country, // Pastikan ini sesuai dengan Enum di Django (ID/IT)
                            "bio": _biography,
                            "category": "men's single", // Bisa ditambahkan field input jika perlu
                            "status": _status.toLowerCase(), // Ubah ke lowercase sesuai Enum Django
                            "world_rank": _rank,
                            "is_featured": false,
                          }),
                        );

                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Player successfully saved!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Mengarahkan ke halaman daftar pemain setelah berhasil
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const PlayerEntryListPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Something went wrong, please try again."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
      ),
    );
  }
}