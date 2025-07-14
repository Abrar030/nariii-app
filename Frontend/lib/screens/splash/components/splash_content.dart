import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../constants.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key, this.text, this.animation, this.image});

  final String? text;
  final String? animation;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        const Text(
          "NARIII",
          style: TextStyle(
            fontSize: 32,
            color: Color(0xFFF40000),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          text ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        const Spacer(),
        if (animation != null)
          Lottie.asset(animation!, height: 250, width: 235, fit: BoxFit.contain)
        else if (image != null)
          Image.asset(image!, height: 265, width: 235),

        const Spacer(flex: 2),
      ],
    );
  }
}
