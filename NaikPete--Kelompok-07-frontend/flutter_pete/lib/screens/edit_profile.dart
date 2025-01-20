import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pete/network/api.dart'; // Sesuaikan dengan path yang benar
import 'package:image_picker_web/image_picker_web.dart'; // Untuk memilih gambar di web

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final String userToken;

  const EditProfileScreen({Key? key, required this.userProfile, required this.userToken}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Network _network = Network();

  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _noHpController;
  late TextEditingController _alamatController;
  late TextEditingController _genderController;
  late TextEditingController _tglLahirController;
  Uint8List? _profileImageBytes; // Gunakan Uint8List untuk menyimpan gambar

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.userProfile['user']['nama']);
    _emailController = TextEditingController(text: widget.userProfile['user']['email']);
    _passwordController = TextEditingController();
    _noHpController = TextEditingController(text: widget.userProfile['user']['no_hp']);
    _alamatController = TextEditingController(text: widget.userProfile['user']['alamat']);
    _genderController = TextEditingController(text: widget.userProfile['user']['gender']);
    _tglLahirController = TextEditingController(text: widget.userProfile['user']['tgl_lahir']);
  }

  Future<void> _pickImage() async {
    // Menggunakan image_picker_web untuk memilih gambar
    final pickedFile = await ImagePickerWeb.getImageAsBytes();
    if (pickedFile != null) {
      setState(() {
        _profileImageBytes = pickedFile; // Simpan gambar sebagai Uint8List
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, String> body = {
        'nama': _namaController.text,
        'email': _emailController.text,
        'password': _passwordController.text.isNotEmpty ? _passwordController.text : '',
        'no_hp': _noHpController.text,
        'alamat': _alamatController.text,
        'gender': _genderController.text,
        'tgl_lahir': _tglLahirController.text,
      };

      try {
        print('Data yang dikirim: $body');
        print('File gambar: $_profileImageBytes');

        final response = await _network.putData(
          '/edit-profile',
          body: body,
          fileBytes: _profileImageBytes, // Kirim gambar sebagai Uint8List
        );

        print('Response dari backend: ${response.body}');

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profil berhasil diperbarui')),
          );
          Navigator.pop(context, true); // Kembali ke halaman profil dengan data baru
        } else if (response.statusCode == 422) {
          final errors = jsonDecode(response.body)['errors'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Validation failed: ${errors.toString()}')),
          );
        } else {
          throw Exception('Gagal memperbarui profil');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImageBytes != null
                      ? MemoryImage(_profileImageBytes!) // Tampilkan gambar yang dipilih
                      : widget.userProfile['user']['foto_profil'] != null
                          ? _buildImageFromBase64(widget.userProfile['user']['foto_profil']) // Tampilkan gambar dari Base64
                          : null, // Jika tidak ada gambar, tampilkan ikon default
                  child: _profileImageBytes == null && widget.userProfile['user']['foto_profil'] == null
                      ? const Icon(Icons.person, size: 50) // Ikon default
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password Baru'),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _noHpController,
                decoration: const InputDecoration(labelText: 'No HP'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _tglLahirController,
                decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk mengonversi Base64 ke Image
  ImageProvider _buildImageFromBase64(String base64String) {
    final Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }
}