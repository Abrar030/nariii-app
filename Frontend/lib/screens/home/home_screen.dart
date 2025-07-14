import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'components/sos_button.dart';
import 'components/title.dart';
import 'components/home_header.dart';
import 'components/contacts.dart';
import 'components/near_ps.dart';
import 'package:nariii_new/features/police_finder/models/police_station_model.dart';
import '../../sos/screens/sos_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _fetchNearbyPoliceStations(); // Comment out or remove this line
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(),
              DiscountBanner(),
              SOSButton(),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              // else if (_errorMessage != null)
              //   Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Text(
              //       _errorMessage!,
              //       style: const TextStyle(color: Colors.red),
              //       textAlign: TextAlign.center,
              //     ),
              //   )
              else
                SpecialOffersWrapper(),
              const SizedBox(height: 20),
              ContactsSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ), 
      // bottomNavigationBar: BottomNavBarFb1(),
    );
  }
}
