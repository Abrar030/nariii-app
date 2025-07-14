import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Padding( 
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("SOS App", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("Version: 1.0.0"),
            Text("Developer: Abrar"),
            SizedBox(height: 20),
            Text("Contact: support@support.app"),
            SizedBox(height: 20),
            Text("This app is designed to help users send SOS alerts in emergencies with audio, video, and location support."),
          ],
        ),
      ),
    );
  }
}
