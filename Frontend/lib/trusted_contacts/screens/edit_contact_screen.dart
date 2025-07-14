// lib/trusted_contacts/screens/edit_contact_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../trusted_contacts/screens/contact_model.dart';

class EditTrustedContactScreen extends StatefulWidget {
  final Contact contact;

  const EditTrustedContactScreen({super.key, required this.contact});

  @override
  State<EditTrustedContactScreen> createState() =>
      _EditTrustedContactScreenState();
}

class _EditTrustedContactScreenState extends State<EditTrustedContactScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _relationController;
  late bool _isNotified;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _emailController = TextEditingController(text: widget.contact.email);
    _relationController = TextEditingController(text: widget.contact.relation);
    _isNotified = widget.contact.isNotified;
    if (widget.contact.assetImagePath != null) {
      _pickedImage = XFile(widget.contact.assetImagePath!);
    }
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
    final updatedContact = widget.contact.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      relation: _relationController.text.trim(),
      isNotified: _isNotified,
      assetImagePath: _pickedImage?.path,
    );
    Navigator.pop(context, updatedContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Contact',
          style: TextStyle(
            color: Colors.white,
          ), // Explicitly set title text color to white
        ),
        backgroundColor: const Color(0xFFF40000),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Explicitly set icon colors to white
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
            ), // Icon color will be white due to iconTheme
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
                child: const Text('SAVE CHANGES'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
