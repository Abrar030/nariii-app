import 'package:flutter/material.dart';
// For a theme switcher, you'd typically use a state management solution like Provider
// For this example, we'll just add a placeholder.
// import 'package:provider/provider.dart';
// import 'package:shop_app/theme_provider.dart'; // Assuming you create a ThemeProvider

const Color kAppPrimaryRed = Color(0xFFF40000);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _backgroundSOS = true;
  bool _notificationsEnabled = true;
  // bool _isDarkMode = false; // Example state for theme

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Color(0xFFF40000),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Color(0xFFF40000),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF40000)),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          _buildSectionHeader(context, "SOS Features"),
          SwitchListTile(
            secondary: const Icon(Icons.phonelink_ring_outlined),
            activeColor: kAppPrimaryRed, // Added active color for the toggle
            value: _backgroundSOS,
            onChanged: (val) {
              setState(() {
                _backgroundSOS = val;
              });
              // TODO: Implement logic to enable/disable background SOS
            },
            title: const Text("Enable Background SOS"),
            subtitle: const Text("Triple press volume or power button even when app is closed"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.vpn_key_outlined),
            title: const Text("Passkey Setup"),
            subtitle: const Text("Choose your emergency trigger"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.passkey);
            },
          ),
          _buildSectionHeader(context, "General"),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            activeColor: kAppPrimaryRed, // Added active color for the toggle
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
              // TODO: Implement logic to enable/disable notifications
            },
            title: const Text("Enable Notifications"),
            subtitle: const Text("Receive safety alerts and SOS updates"),
          ),
          const Divider(),
          // Example for Theme Switcher (requires a ThemeProvider)
          // SwitchListTile(
          //   secondary: const Icon(Icons.brightness_6_outlined),
          //   activeColor: kAppPrimaryRed, // Example for theme toggle
          //   title: const Text("Dark Mode"),
          //   value: Provider.of<ThemeProvider>(context).isDarkMode,
          //   onChanged: (value) {
          //     Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          //   },
          // ),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text("App Theme"),
            subtitle: const Text("Choose between light and dark mode"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to a theme selection screen or show a dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Theme selection UI to be implemented.")),
              );
            },
          ),

          _buildSectionHeader(context, "Legal & Information"),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text("Terms of Service"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Terms of Service screen or open a web link
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Terms of Service to be implemented.")),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Policy"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Privacy Policy screen or open a web link
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Privacy Policy to be implemented.")),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            subtitle: const Text("App information"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.about);
            },
          ),
          const SizedBox(height: 20), // Add some padding at the bottom
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class AppRoutes {
  // Existing routes

  static const String passkey = '/passkey'; // Define the passkey route
  static const String about = '/about'; // Define the about route
}
