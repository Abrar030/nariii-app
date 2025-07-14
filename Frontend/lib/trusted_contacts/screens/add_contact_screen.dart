// lib/trusted_contacts/screens/add_contact_screen.dart
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../trusted_contacts/screens/contact_model.dart';

class AddTrustedContactScreen extends StatefulWidget {
  const AddTrustedContactScreen({super.key});

  @override
  State<AddTrustedContactScreen> createState() => _AddTrustedContactScreenState();
}

class _AddTrustedContactScreenState extends State<AddTrustedContactScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _relationController = TextEditingController();
  bool _isNotified = true;
  XFile? _pickedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  void _saveContact() {
    final newContact = Contact(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      relation: _relationController.text.trim(),
      isNotified: _isNotified,
      assetImagePath: _pickedImage?.path,
    );
    Navigator.pop(context, newContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Contact',
          style: TextStyle(color: Colors.white), // Explicitly set title text color to white
        ),
        backgroundColor: const Color(0xFFF40000),
        iconTheme: const IconThemeData(color: Colors.white), // Explicitly set icon colors to white
        actions: [
          IconButton(
            icon: const Icon(Icons.save), // Icon color will be white due to iconTheme
            onPressed: _saveContact,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Builder(builder: (BuildContext context) {
                ImageProvider<Object>? backgroundImage;
                if (_pickedImage != null) {
                  if (kIsWeb) {
                    backgroundImage = NetworkImage(_pickedImage!.path);
                  } else {
                    backgroundImage = FileImage(File(_pickedImage!.path));
                  }
                }
                return CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: backgroundImage,
                  child: _pickedImage == null
                      ? const Icon(Icons.camera_alt, size: 36, color: Colors.grey)
                      : null,
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _relationController,
              decoration: const InputDecoration(labelText: 'Relation'),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _isNotified,
              activeColor: const Color(0xFFF40000), // Set the active color of the switch
              onChanged: (value) => setState(() => _isNotified = value),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF40000),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'SAVE CONTACT',
                  style: TextStyle(color: Colors.white), // Make button text white
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}