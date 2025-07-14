import 'dart:async';
import 'package:flutter/material.dart';
import '../sos_log_repository.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  static const int _countdownSeconds = 10;
  int _currentCountdown = _countdownSeconds;
  Timer? _timer;
  String _statusText = "SOS will be sent in $_countdownSeconds seconds...";

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentCountdown > 0) {
        setState(() {
          _currentCountdown--;
          _statusText = "SOS will be sent in $_currentCountdown seconds...";
        });
      } else {
        setState(() {
          _statusText = "SOS ACTIVATED! Notifying contacts...";
          // Log SOS event
          SOSLogRepository().addLog({
            'date': DateTime.now().toIso8601String(),
            'method': 'App Button',
            'status': 'Sent',
            'video': true, // or false if not applicable
          });
          print("SOS Triggered!");
        });
        timer.cancel();
        // Pop after a short delay to show the activated message
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  void cancelSOS() {
    _timer?.cancel();
    setState(() {
      _statusText = "SOS Canceled.";
    });
    // Pop after a short delay to show the canceled message
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 120,
              ),
              const SizedBox(height: 20),
              Text(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              if (_timer?.isActive ?? false)
                SizedBox(
                  height: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: cancelSOS,
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
