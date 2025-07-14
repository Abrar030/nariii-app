import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../sos_log_repository.dart';
import '../../main.dart' show routeObserver;

const String emergencyHistoryScreenRouteName = "/emergency_history";

class EmergencyHistoryScreen extends StatefulWidget {
  const EmergencyHistoryScreen({super.key});

  @override
  State<EmergencyHistoryScreen> createState() => _EmergencyHistoryScreenState();
}

class _EmergencyHistoryScreenState extends State<EmergencyHistoryScreen>
    with RouteAware {
  final _repository = SOSLogRepository();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    print('didPopNext called, refreshing history!');
    setState(() {}); // Refresh when returning to this screen
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sosLogs = _repository.logs;
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency History")),
      body: sosLogs.isEmpty
          ? const Center(child: Text('No SOS events logged yet.'))
          : ListView.builder(
              itemCount: sosLogs.length,
              itemBuilder: (context, index) {
                final log = sosLogs[index];
                final dateTime = DateTime.tryParse(log['date'] ?? '') ?? DateTime.now();
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title:
                        Text(DateFormat.yMMMd().add_jms().format(dateTime)),
                    subtitle: Text(
                        "Triggered: " +
                            (log['method'] ?? '') +
                            "\nStatus: " +
                            (log['status'] ?? '')),
                    trailing: log['video'] == true
                        ? const Icon(Icons.videocam, color: Colors.green)
                        : const Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
            ),
    );
  }
}
