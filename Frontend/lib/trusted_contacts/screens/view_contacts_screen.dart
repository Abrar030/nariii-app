// lib/trusted_contacts/screens/view_contacts_screen.dart
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../trusted_contacts/screens/contact_model.dart';
import 'package:nariii_new/trusted_contacts/screens/add_contact_screen.dart';
import 'package:nariii_new/trusted_contacts/screens/edit_contact_screen.dart';
import 'package:nariii_new/screens/home/components/contacts.dart';

class ViewContactsScreen extends StatefulWidget {
  const ViewContactsScreen({super.key});

  @override
  State<ViewContactsScreen> createState() => _ViewContactsScreenState();
}

class _ViewContactsScreenState extends State<ViewContactsScreen> {
  List<Contact> get _contacts => ContactsRepository.contacts;

  Future<void> _addNewContact() async {
    final newContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(builder: (context) => const AddTrustedContactScreen()),
    );
    if (newContact != null) {
      setState(() {
        ContactsRepository.contacts.add(newContact);
      });
    }
  }

  Future<void> _editContact(int index) async {
    final updatedContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTrustedContactScreen(contact: _contacts[index]),
      ),
    );
    if (updatedContact != null) {
      setState(() {
        ContactsRepository.contacts[index] = updatedContact;
      });
    }
  }

  Future<bool> _confirmDelete(int index) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Contact'),
            content: const Text('Are you sure you want to delete this contact?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewContact,
            tooltip: 'Add New Contact',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return Dismissible(
            key: ValueKey('${contact.name}$index'),
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              color: Colors.blue,
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            secondaryBackground: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                await _editContact(index);
                return false;
              } else {
                return await _confirmDelete(index);
              }
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                setState(() {
                  ContactsRepository.contacts.removeAt(index);
                });
              }
            },
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                leading: Builder(
                  builder: (context) {
                    ImageProvider<Object>? imageProvider;
                    if (contact.assetImagePath != null && contact.assetImagePath!.isNotEmpty) {
                      if (contact.assetImagePath!.startsWith('http') || contact.assetImagePath!.startsWith('blob:')) {
                        imageProvider = NetworkImage(contact.assetImagePath!);
                      } else if (!kIsWeb && !contact.assetImagePath!.contains('assets/')) {
                        imageProvider = FileImage(File(contact.assetImagePath!));
                      } else {
                        imageProvider = AssetImage(contact.assetImagePath!);
                      }
                    }
                    return CircleAvatar(
                      radius: 28,
                      backgroundColor: contact.assetImagePath != null ? Colors.grey[200] : const Color(0xFFF40000),
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? Text(
                              contact.name.isNotEmpty ? contact.name[0] : '?',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                            )
                          : null,
                    );
                  },
                ),
                title: Text(
                  contact.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${contact.relation} • ${contact.email}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    Text(
                      contact.isNotified ? 'Notification: Active' : 'Notification: Disabled',
                      style: TextStyle(color: contact.isNotified ? Colors.green : Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
