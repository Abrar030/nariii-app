// lib/models/contact_model.dart
class Contact {
  final String name;
  final String email;
  final String relation;
  final bool isNotified;
  final String? assetImagePath; // Added field for asset image path

  const Contact({
    required this.name,
    required this.email,
    required this.relation,
    required this.isNotified,
    this.assetImagePath, // Added to constructor
  });

  Contact copyWith({
    String? name,
    String? email,
    String? relation,
    bool? isNotified,
    String? assetImagePath,
  }) {
    return Contact(
      name: name ?? this.name,
      email: email ?? this.email,
      relation: relation ?? this.relation,
      isNotified: isNotified ?? this.isNotified,
      assetImagePath: assetImagePath ?? this.assetImagePath,
    );
  }
}
