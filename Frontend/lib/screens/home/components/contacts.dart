import 'package:flutter/material.dart';
import 'package:nariii_new/trusted_contacts/screens/contact_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;

class ContactsRepository {
  static final List<Contact> contacts = [
    Contact(
      name: 'Doe',
      email: 'doe@example.com',
      relation: 'Brother',
      assetImagePath: 'assets/images/p1.jpeg',
      isNotified: true,
    ),
    Contact(
      name: 'Jane ',
      email: 'jane@example.com',
      relation: 'Sister',
      assetImagePath: 'assets/images/p2.jpeg',
      isNotified: false,
    ),
    Contact(
      name: 'Brown',
      email: 'brown@example.com',
      relation: 'Friend',
      assetImagePath: 'assets/images/p3.jpeg',
      isNotified: false,
    ),
    Contact(
      name: 'Tonny',
      email: 'Tonny@example.com',
      relation: 'Sister',
      assetImagePath: 'assets/images/p4.jpeg',
      isNotified: false,
    ),
  ];
}

class ContactsSection extends StatelessWidget {
  const ContactsSection({
    super.key,
    this.color = const Color(0xFFF40000),
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    final contacts = ContactsRepository.contacts;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
            child: Text(
              'Contacts',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HoverCard(
                  child: ContactTile(
                    contact: contact,
                    themeColor: color,
                    onCall: () {
                      print("Calling ${contact.name}");
                    },
                    onMessage: () {
                      print("Messaging ${contact.name}");
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget child;
  const HoverCard({super.key, required this.child});
  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _hovering
            ? (Matrix4.translationValues(0, -4, 0)..scale(1.02))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
    required this.themeColor,
    required this.onCall,
    required this.onMessage,
  });

  final Contact contact;
  final Color themeColor;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  ImageProvider<Object>? _getImageProvider(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }
    try {
      if (path.startsWith('http') || path.startsWith('blob:')) {
        return NetworkImage(path);
      } else if (!kIsWeb && !path.contains('assets/')) {
        return FileImage(File(path));
      } else {
        return AssetImage(path);
      }
    } catch (e) {
      // It's good practice to log errors rather than swallowing them silently.
      print("Could not load image for path: $path, error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getImageProvider(contact.assetImagePath);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: imageProvider != null ? Colors.grey[200] : themeColor,
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Text(
                    contact.name.isNotEmpty ? contact.name[0] : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  contact.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  contact.relation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Colors.grey[700],
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        contact.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[800],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  contact.isNotified ? 'Notification: Active' : 'Notification: Disabled',
                  style: TextStyle(
                    color: contact.isNotified ? Colors.green : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ContactActionButton(
                icon: Icons.call_outlined,
                color: themeColor,
                onPressed: onCall,
                tooltip: 'Call ${contact.name}',
              ),
              const SizedBox(width: 4),
              _ContactActionButton(
                icon: Icons.message_outlined,
                color: themeColor,
                onPressed: onMessage,
                tooltip: 'Message ${contact.name}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;

  const _ContactActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: color, size: 22),
          ),
        ),
      ),
    );
  }
}
