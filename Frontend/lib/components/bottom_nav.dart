// import 'package:flutter/material.dart';
// import 'package:shop_app/trusted_contacts/screens/add_contact_screen.dart';
// import 'package:shop_app/trusted_contacts/screens/view_contacts_screen.dart';


// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Your main content here, e.g.:
//       body: Center(child: Text('Home Screen')),
//       bottomNavigationBar: const BottomNavBarFb1(),
//     );
//   }
// }

// class BottomNavBarFb1 extends StatelessWidget {
//   const BottomNavBarFb1({Key? key}) : super(key: key);

//   final primaryColor = const Color(0xFFF40000);
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.white,
//       child: SizedBox(
//         height: 56,
//         width: MediaQuery.of(context).size.width,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 25.0, right: 25.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconBottomBar(
//                   text: "",
//                   icon: Icons.contacts,
//                   selected: true,
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => ViewContact()));
//                   }),
//               IconBottomBar(
//                   text: "Search",
//                   icon: Icons.search_outlined,
//                   selected: false,
//                   onPressed: () {}),
//               IconBottomBar2(
//                   text: "Home",
//                   icon: Icons.home,
//                   selected: false,
//                   onPressed: () {
                   
//                   }),
//               IconBottomBar(
//                   text: "Cart",
//                   icon: Icons.local_grocery_store_outlined,
//                   selected: false,
//                   onPressed: () {}),
//               IconBottomBar(
//                   text: "Calendar",
//                   icon: Icons.date_range_outlined,
//                   selected: false,
//                   onPressed: () {})
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class IconBottomBar extends StatelessWidget {
//   const IconBottomBar(
//       {Key? key,
//       required this.text,
//       required this.icon,
//       required this.selected,
//       required this.onPressed})
//       : super(key: key);
//   final String text;
//   final IconData icon;
//   final bool selected;
//   final Function() onPressed;

//   final primaryColor = const Color(0xFFF40000);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed: onPressed,
//           icon: Icon(
//             icon,
//             size: 25,
//             color: selected ? primaryColor : Colors.black54,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class IconBottomBar2 extends StatelessWidget {
//   const IconBottomBar2(
//       {Key? key,
//       required this.text,
//       required this.icon,
//       required this.selected,
//       required this.onPressed})
//       : super(key: key);
//   final String text;
//   final IconData icon;
//   final bool selected;
//   final Function() onPressed;
//   final primaryColor = const Color(0xFFF40000);
//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       backgroundColor: primaryColor,
//       child: IconButton(
//         onPressed: onPressed,
//         icon: Icon(
//           icon,
//           size: 25,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
