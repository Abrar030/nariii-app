import 'package:flutter/material.dart';

import '../community/screens/community_screen.dart';

import '../screens/home/home_screen.dart';

import '../trusted_contacts/screens/view_contacts_screen.dart';

import '../screens/profile/screens/account_screen.dart';

const Color kPrimaryRed = Color(0xFFF40000);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});
  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentIndex = 0;

  // Define the pages that correspond to each tab
  final List<Widget> pages = [
    HomeScreen(), // Index 0: Home
    ViewContactsScreen(), // Index 1: Contact
    CommunityListScreen(), // Index 2: Community
    AccountScreen(), // Index 3: Account - Changed to AccountScreen
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  BottomNavigationBarItem buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: kPrimaryRed),
      activeIcon: Icon(icon, color: Colors.black),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12, 
              blurRadius: 10, 
              spreadRadius: 2,
              offset: Offset(0, -2))
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: kPrimaryRed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            elevation: 10, // Added elevation here
            items: [
              buildNavItem(Icons.home_rounded, "Home"),
              buildNavItem(Icons.contacts_rounded, "Contact"),
              buildNavItem(Icons.group_rounded, "Community"),
              buildNavItem(Icons.account_circle_rounded, "Account"),
            ],
          ),
        ),
      ),
    );
  }
}