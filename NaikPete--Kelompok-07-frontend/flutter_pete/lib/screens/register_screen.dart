import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:file_picker/file_picker.dart'; // For Flutter Web
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:image_picker/image_picker.dart'; // For Android/iOS
import 'package:flutter_pete/screens/login_screen.dart'; // Adjust import as needed

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  // Variables for dropdowns
  String? selectedRole;
  String? selectedGender;

  // Variables for profile image
  Uint8List? webImage; // For Flutter Web
  File? profileImage; // For Android/iOS

  // Function to validate the form
  bool validateForm() {
    if (nameController.text.isEmpty) {
      showError("Nama wajib diisi");
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

  // Function to check if a string is numeric
  bool isNumeric(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  // Function to show error messages
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Function to pick an image
  Future<void> pickImage() async {
    if (kIsWeb) {
      // For Flutter Web
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          webImage = result.files.first.bytes;
        });
      }
    } else {
      // For Android/iOS
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          profileImage = File(image.path);
        });
      }
    }
  }

  // Function to select birth date
  Future<void> selectBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthDateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Function to register the user
  Future<void> registerUser() async {
    if (!validateForm()) {
      return; // Stop if validation fails
    }

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'nama': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'no_hp': phoneController.text,
      'alamat': cityController.text,
      'gender': selectedGender,
      'tgl_lahir': birthDateController.text,
      'role': selectedRole,
    };

    // Convert image to base64 if available
    if (kIsWeb && webImage != null) {
      requestBody['foto_profil'] = base64Encode(webImage!);
    } else if (!kIsWeb && profileImage != null) {
      List<int> imageBytes = await profileImage!.readAsBytes();
      requestBody['foto_profil'] = base64Encode(imageBytes);
    }

    // Make the HTTP POST request
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/register'), // Replace with your backend URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 201) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        // Navigate to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Handle errors
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['message']}')),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
            Navigator.pop(context);
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

            // Profile Picture
            GestureDetector(
              onTap: pickImage,
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: kIsWeb
                      ? (webImage != null ? MemoryImage(webImage!) : null)
                      : (profileImage != null ? FileImage(profileImage!) : null),
                  child: (webImage == null && profileImage == null)
                      ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Name Field
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Email Field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),

            // Phone Field
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

            // Birth Date Field
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

            // Gender Dropdown
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

            // City Field
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Password Field
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

            // Role Dropdown
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

            // Register Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: registerUser,
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