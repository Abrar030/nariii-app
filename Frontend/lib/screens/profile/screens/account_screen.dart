import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;
import 'editprofile_screen.dart';
import 'changepassword_screen.dart';
import 'package:nariii_new/screens/sign_in/sign_in_screen.dart'; // Assuming SignInScreen is in this path
import 'emergency_history_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const Color _destructiveActionColor = Color(0xFFF40000);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Define a path for your default avatar asset
  static const String _defaultProfileAssetPath =
      'assets/images/profile.jpeg'; // Ensure this asset exists

  // Store user data in the state
  String _userName = "Caroline"; // Initial Placeholder
  String _userEmail = "Caroline@example.com"; // Initial Placeholder
  String _userPhone = "+1234567890"; // Initial Placeholder
  String? _profileImageUrl; // Initial Placeholder, can be null

  @override
  void initState() {
    super.initState();
    // In a real app, you would fetch this data from a service or local storage
    // For now, we use the initial placeholders.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Builder(builder: (context) {
              ImageProvider<Object> backgroundImage;
              if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
                if (_profileImageUrl!.startsWith('http') ||
                    _profileImageUrl!.startsWith('blob:')) {
                  backgroundImage = NetworkImage(_profileImageUrl!);
                } else if (!kIsWeb && File(_profileImageUrl!).existsSync()) {
                  backgroundImage = FileImage(File(_profileImageUrl!));
                } else {
                  backgroundImage = const AssetImage(_defaultProfileAssetPath);
                }
              } else {
                backgroundImage = const AssetImage(_defaultProfileAssetPath);
              }
              return CircleAvatar(
                radius: 50,
                backgroundImage: backgroundImage,
              );
            }),
            const SizedBox(height: 12),
            Text(
              _userName,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold, color: Color(0xFFF40000)),
            ),
            const SizedBox(height: 4),
            if (_userEmail.isNotEmpty)
              Text(
                _userEmail,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
              ),
            if (_userEmail.isNotEmpty) const SizedBox(height: 4),
            if (_userPhone.isNotEmpty)
              Text(
                _userPhone,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
              ),
            _buildAccountMenuOption(
              context: context,
              icon: Icons.person_outline,
              text: "Edit Profile",
              onTap: () async {
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      initialName: _userName,
                      initialEmail: _userEmail,
                      initialPhone: _userPhone,
                      initialProfileImageUrl: _profileImageUrl,
                    ),
                  ),
                );

                if (result != null && mounted) {
                  setState(() {
                    _userName = result['name'] as String? ?? _userName;
                    _userEmail = result['email'] as String? ?? _userEmail;
                    _userPhone = result['phone'] as String? ?? _userPhone;
                    _profileImageUrl = result['profileImageUrl'] as String?;
                  });
                }
              },
            ),
            _buildAccountMenuOption(
              context: context,
              icon: Icons.lock_outline,
              text: "Change Password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
              },
            ),
            _buildAccountMenuOption(
              context: context,
              icon: Icons.history_outlined,
              text: "View Emergency History",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmergencyHistoryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildAccountMenuOption(
              context: context,
              icon: Icons.delete_outline,
              text: "Delete Account",
              textColor: AccountScreen._destructiveActionColor,
              iconColor: AccountScreen._destructiveActionColor,
              onTap: () {
                // Show confirmation dialog
                print("Delete Account Tapped");
              },
            ),
            _buildAccountMenuOption(
              context: context,
              icon: Icons.logout_outlined,
              text: "Logout",
              textColor: AccountScreen._destructiveActionColor,
              iconColor: AccountScreen._destructiveActionColor,
              onTap: () {
                // Navigate to the SignInScreen and remove all previous routes
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInScreen
                      .routeName, // Ensure SignInScreen.routeName is correctly defined
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountMenuOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Card(
        color: Colors.white,
        elevation: 2.0, // Increased elevation to make it stand out more
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(
            icon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight:
                  textColor != null ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          trailing: textColor == null
              ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600])
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
