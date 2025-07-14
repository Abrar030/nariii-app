import 'package:flutter/material.dart';

const Color kAppPrimaryRed = Color(0xFFF40000);

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "Latest Safety News",
        "subtitle": "${DateTime.now().hour}:00 - ${DateTime.now().minute} min ago: New safety news article available.",
        "time": "Just now",
        "icon": Icons.article_rounded,
        "color": Colors.blueAccent,
      },
      {
        "title": "Important Alert",
        "subtitle": "Breaking: Major update in women safety news.",
        "time": "1 min ago",
        "icon": Icons.announcement_rounded,
        "color": Colors.redAccent,
      },
      {
        "title": "SOS Alert Sent",
        "subtitle": "Your SOS alert was sent successfully.",
        "time": "2 min ago",
        "icon": Icons.warning_amber_rounded,
        "color": Colors.redAccent,
      },
      {
        "title": "Contact Added",
        "subtitle": "You added Raj as a trusted contact.",
        "time": "10 min ago",
        "icon": Icons.person_add_alt_1_rounded,
        "color": Colors.green,
      },
      {
        "title": "Community Update",
        "subtitle": "Curfew in your area after 10 PM.",
        "time": "1 hour ago",
        "icon": Icons.campaign_rounded,
        "color": Colors.blue,
      },
      {
        "title": "Safety Tip",
        "subtitle": "Always keep your emergency contacts updated.",
        "time": "Today",
        "icon": Icons.shield_rounded,
        "color": Colors.orange,
      },
    ];
  
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.notifications_active_outlined,
              color: Color(0xFFF40000),
            ),
            SizedBox(width: 8),
            Text(
              "Notifications",
              style: TextStyle(
                color: Color(0xFFF40000),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
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
      backgroundColor: Colors.grey[100], // Light grey background for the screen
      body: notifications.isEmpty
          ? Center( // Display this if there are no notifications
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 70, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    "No new notifications",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder( // Changed from ListView.separated for better card handling
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Padding for the list
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return Card( // Each notification item is a Card
            color: Colors.white, // Explicit white background for the card
            elevation: 3.0, // Elevation to make the card "pop"
            margin: const EdgeInsets.only(bottom: 16.0), // Space between cards
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded corners for a modern look
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside the ListTile
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: (n["color"] as Color).withOpacity(0.15), // Softer background for avatar
                child: Icon(n["icon"] as IconData, color: n["color"] as Color, size: 26), // Icon uses the notification's theme color
              ),
              title: Text(
                n["title"] as String,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[850]),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0), // Space between title and subtitle
                child: Text(
                  n["subtitle"] as String,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
              trailing: Text(
                n["time"] as String,
                style: TextStyle(color: Colors.grey[500], fontSize: 12)
              ),
            ),
          );
        },
      ),
    );
  }
}