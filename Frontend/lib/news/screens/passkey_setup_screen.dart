import 'package:flutter/material.dart';

class PasskeySetupScreen extends StatefulWidget {
  const PasskeySetupScreen({super.key});

  @override
  State<PasskeySetupScreen> createState() => _PasskeySetupScreenState();
}

class _PasskeySetupScreenState extends State<PasskeySetupScreen> {
  String selectedMethod = "volume";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Passkey Setup")),
      body: Column(
        children: [ 
          RadioListTile(
            value: "power",
            groupValue: selectedMethod,
            title: const Text("Power Button 3x"),
            onChanged: (val) => setState(() => selectedMethod = val!),
          ),
          RadioListTile(
            value: "volume",
            groupValue: selectedMethod,
            title: const Text("Volume Down 3x"),
            onChanged: (val) => setState(() => selectedMethod = val!),
          ),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: () {}, child: const Text("Test Trigger")),
        ],
      ),
    );
  }
}
