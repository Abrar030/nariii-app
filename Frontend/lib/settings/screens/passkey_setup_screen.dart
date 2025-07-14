import 'package:flutter/material.dart';

class PasskeySetupScreen extends StatefulWidget {
  const PasskeySetupScreen({super.key});

  @override
  State<PasskeySetupScreen> createState() => _PasskeySetupScreenState();
}

class _PasskeySetupScreenState extends State<PasskeySetupScreen> {
  String _selected = 'volume';
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Passkey Setup")),
      body: Column(
        children: [
          RadioListTile(
            title: const Text("Volume Down 3x"),
            value: 'volume',
            groupValue: _selected,
            onChanged: (val) {
              setState(() => _selected = val!);
            },
          ),
          RadioListTile(
            title: const Text("Power Button 3x"),
            value: 'power',
            groupValue: _selected,
            onChanged: (val) {
              setState(() => _selected = val!);
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Test trigger sent")),
              );
            },
            child: const Text("Test Trigger"),
          ),
        ],
      ),
    );
  }
}
