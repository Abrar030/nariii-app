import 'package:flutter/material.dart';
import 'package:nariii_new/screens/splash/splash_screen.dart';

import 'routes.dart';
import 'theme.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nariii-Safety',
      theme: AppTheme.lightTheme(context),
      navigatorObservers: [routeObserver], // <-- THIS IS REQUIRED
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
     
  }
}
