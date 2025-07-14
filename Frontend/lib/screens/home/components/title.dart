import 'package:flutter/material.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      // decoration: BoxDecoration(
      //   color: const Color(0xFFF40000),
      //   borderRadius: BorderRadius.circular(20),
      // ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 20),
          children: [
            TextSpan(
              text: "EMERGENCY ALERT \n",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF40000),
              ),
            ),
            TextSpan(text: "Welcome to Narrii"),
          ],
        ),
        textAlign: TextAlign.center, // Add this line
      ),
    );
  }
}
