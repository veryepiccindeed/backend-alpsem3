import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:file_picker/file_picker.dart'; // Untuk Flutter Web
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart'; // Untuk Android/iOS
import 'package:flutter_pete/screens/login_screen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers untuk input data
  final TextEditingController NameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  // Variabel untuk menyimpan pilihan peran, gender, dan validasi
  String? selectedRole;
  String? selectedGender;

  // Foto profil
  Uint8List? webImage; // Untuk Flutter Web
  File? profileImage; // Untuk Android/iOS

  // Fungsi untuk validasi input
  bool validateForm() {
  if (NameController.text.isEmpty) {
    showError("Nama depan dan belakang wajib diisi");
    return false;
  }
  if (emailController.text.isEmpty || !emailController.text.contains('@')) {
    showError("Masukkan email yang valid");
    return false;
  }
  if (phoneController.text.isEmpty || !isNumeric(phoneController.text)) {
    showError("Nomor telepon hanya boleh berisi angka");
    return false;
  }
  if (birthDateController.text.isEmpty) {
    showError("Tanggal lahir wajib diisi");
    return false;
  }
  if (selectedGender == null) {
    showError("Pilih jenis kelamin");
    return false;
  }
  if (cityController.text.isEmpty) {
    showError("Alamat wajib diisi");
    return false;
  }
  if (passwordController.text.isEmpty || passwordController.text.length < 6) {
    showError("Password harus minimal 6 karakter");
    return false;
  }
  if (selectedRole == null) {
    showError("Silakan pilih peran Anda");
    return false;
  }
  return true;
}

  // Fungsi untuk mengecek apakah input hanya angka
  bool isNumeric(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  // Fungsi untuk menampilkan pesan error
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Fungsi untuk memilih foto profil
  Future<void> pickImage() async {
    if (kIsWeb) {
      // Gunakan file_picker untuk Flutter Web
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          webImage = result.files.first.bytes; // Data gambar dalam bentuk Uint8List
        });
      }
    } else {
      // Gunakan image_picker untuk Android/iOS
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          profileImage = File(image.path);
        });
      }
    }
  }

  // Fungsi untuk memilih tanggal lahir
  Future<void> selectBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Tanggal minimal
      lastDate: DateTime.now(), // Tanggal maksimal adalah hari ini
    );

    if (pickedDate != null) {
      setState(() {
        birthDateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Fungsi untuk mengirim data ke backend dan navigasi ke halaman login
  void register() async {
  if (!validateForm()) {
    return; // Jika validasi gagal, jangan lanjut
  }


  // Prepare the data to be sent
  Map<String, dynamic> requestData = {
    "name": NameController, // Gunakan field name yang sudah digabungkan
    "email": emailController.text,
    "password": passwordController.text,
    "password_confirmation": passwordController.text, // Tambahkan konfirmasi password
    "no_hp": phoneController.text,
    "alamat": cityController.text,
    "gender": selectedGender, // Pastikan nilai ini sesuai dengan yang diharapkan server
    "tgl_lahir": birthDateController.text,
    "role": selectedRole, // Pastikan nilai ini sesuai dengan yang diharapkan server
  };

  // Tambahkan profile image (jika tersedia)
  if (kIsWeb && webImage != null) {
    requestData["profile_image"] = base64Encode(webImage!); // Encode gambar ke base64 untuk web
  } else if (!kIsWeb && profileImage != null) {
    requestData["profile_image"] = await http.MultipartFile.fromPath('profile_image', profileImage!.path); // Untuk mobile
  }

  // Log the request data
  print("Request Data: $requestData");

  // Kirim request ke server
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/register'),
      body: jsonEncode(requestData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Sukses
      print("Registration successful!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // Handle error
      print("Error: ${response.statusCode}");
      print("Response: ${response.body}");
      showError("Registration failed. Please try again.");
    }
  } catch (e) {
    // Handle network errors
    print("Error: $e");
    showError("Network error. Please check your connection.");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Daftar',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Isi Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Foto Profil
            GestureDetector(
              onTap: pickImage,
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: kIsWeb
                      ? (webImage != null ? MemoryImage(webImage!) : null) // Web
                      : (profileImage != null ? FileImage(profileImage!) : null), // Mobile
                  child: (webImage == null && profileImage == null)
                      ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Nama Depan
            TextField(
              controller: NameController,
              decoration: const InputDecoration(
                labelText: 'Nama depan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Input Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),

            // Input Nomor Telepon
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nomor telepon',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 15),

            // Input Tanggal Lahir
            TextField(
              controller: birthDateController,
              readOnly: true,
              onTap: selectBirthDate,
              decoration: const InputDecoration(
                labelText: 'Tanggal lahir',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 15),

            // Dropdown untuk memilih jenis kelamin
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(
                labelText: 'Jenis kelamin',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            const SizedBox(height: 15),

            // Input Kota
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Input Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 15),

            // Dropdown untuk memilih peran
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: 'Peran Anda',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Driver', child: Text('Driver')),
                DropdownMenuItem(value: 'User', child: Text('User')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Tombol Selanjutnya
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: register,
              child: const Text(
                'Selanjutnya',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
