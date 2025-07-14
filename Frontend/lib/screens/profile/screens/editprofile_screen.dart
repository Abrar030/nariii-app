import 'dart:io'; // Import for File
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import for ImagePicker

class EditProfileScreen extends StatefulWidget {
  static String routeName = "/edit_profile"; // Corrected routeName
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String? initialProfileImageUrl;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
    this.initialProfileImageUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Define a path for your default avatar asset, consistent with AccountScreen
  static const String _defaultProfileAssetPath = 'assets/images/profile.jpeg';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _emailController.text = widget.initialEmail;
    _phoneController.text = widget.initialPhone;
    _profileImageUrl = widget.initialProfileImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Ask to pick from gallery or camera, here we use gallery
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImageUrl = pickedFile.path; // Store the local file path
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      // Optionally, show a SnackBar to the user if image picking fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return; // If form is not valid, do nothing
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network request or database operation
      await Future.delayed(const Duration(seconds: 2));

      // Process data and update profile
      String name = _nameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;

      final updatedData = {
        'name': name,
        'email': email,
        'phone': phone,
        'profileImageUrl': _profileImageUrl,
      };

      // Here, you would typically update the user profile in your backend or database.
      // If _profileImageUrl is a local file path, you'd upload it here and get a new URL.
      // For this example, we'll just print the updated information and assume _profileImageUrl is handled.
      print("Saving profile with: $updatedData");

      // Show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context, updatedData); // Return the updated data
      }
    } catch (e) {
      // Handle errors, e.g., show an error SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      }
      print("Error saving profile: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white), // Title text white
        ),
        backgroundColor: const Color(0xFFF40000), // AppBar background red
        iconTheme: const IconThemeData(color: Colors.white), // Icons white
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage, // Call the image picker function
                child: Builder(builder: (BuildContext context) {
                  ImageProvider<Object> backgroundImage;
                  if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
                    if (_profileImageUrl!.startsWith('http')) {
                      backgroundImage = NetworkImage(_profileImageUrl!);
                    } else if (kIsWeb) {
                      backgroundImage = NetworkImage(_profileImageUrl!);
                    } else {
                      File imageFile = File(_profileImageUrl!);
                      if (imageFile.existsSync()) {
                        backgroundImage = FileImage(imageFile);
                      } else {
                        backgroundImage = const AssetImage(_defaultProfileAssetPath);
                      }
                    }
                  } else {
                    backgroundImage = const AssetImage(_defaultProfileAssetPath);
                  }
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: backgroundImage,
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  // Add more specific phone validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFF40000), // Red to match AppBar
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
