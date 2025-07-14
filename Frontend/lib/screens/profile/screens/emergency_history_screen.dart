import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:nariii_new/sos/screens/sos_event.dart';

class EmergencyHistoryScreen extends StatefulWidget {
  const EmergencyHistoryScreen({super.key});

  static const String routeName = "/emergency_history"; // Add a route name

  @override
  State<EmergencyHistoryScreen> createState() => _EmergencyHistoryScreenState();
}

class _EmergencyHistoryScreenState extends State<EmergencyHistoryScreen> {
  // Placeholder for SOS event data. Replace with actual data fetching
  List<SOSEvent> sosEvents = [
    SOSEvent(
      dateTime: DateTime.now().subtract(const Duration(minutes: 30)),
      triggerMethod: "Button",
      contactsNotified: ["Mom", "Police"],
      videoSent: true,
      audioSent: false,
    ),
    SOSEvent(
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      triggerMethod: "Passkey",
      contactsNotified: ["Dad", "Ambulance"],
      videoSent: false,
      audioSent: true,
    ),
    // Add more sample data or fetch from a data source
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency History"),
      ),
      body: sosEvents.isEmpty
          ? const Center(child: Text("No emergency history found."))
          : ListView.builder(
              itemCount: sosEvents.length,
              itemBuilder: (context, index) {
                final event = sosEvents[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      DateFormat('MMM d, yyyy h:mm a').format(event.dateTime),
                    ),
                    subtitle: Text(
                      "Trigger: ${event.triggerMethod} | Contacts: ${event.contactsNotified.join(", ")}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(event.videoSent ? Icons.videocam : Icons.videocam_off, color: event.videoSent ? Colors.green : Colors.grey),
                        const SizedBox(width: 8),
                        Icon(event.audioSent ? Icons.mic : Icons.mic_off, color: event.audioSent ? Colors.green : Colors.grey),
                      ],
                    ),
                    onTap: () {
                      // Navigate to detailed view (not implemented here)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on event at ${DateFormat('MMM d, yyyy h:mm a').format(event.dateTime)}')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}