import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nariii_new/screens/home/components/contacts.dart'; // Using a known widget for the home screen
import 'package:nariii_new/sos/screens/sos_screen.dart';

class AppController extends StatefulWidget {
  const AppController({Key? key}) : super(key: key);

  @override
  State<AppController> createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  static const platform = MethodChannel('com.nariii.sos/volume');
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<void> _handleMethod(MethodCall call) async {
    if (call.method == 'triggerSOS') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => const SOSScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nariii',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // NOTE: Replace this with your actual home screen widget
      home: const Scaffold(body: ContactsSection()),
    );
  }
}