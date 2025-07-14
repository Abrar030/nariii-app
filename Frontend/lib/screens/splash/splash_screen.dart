import 'package:flutter/material.dart';

import '../../constants.dart';
import '../sign_in/sign_in_screen.dart';
import 'page2.dart'; // Import part 1
import 'page3.dart'; // Import part 2
import 'components/splash_content.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  // Combine the splash data from the two parts
  final List<Map<String, String>> splashData = [...splashDataPart1, ...splashDataPart2];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: _pageController, // Assign the controller here
                  onPageChanged: (value) {
                    // When the page changes, update the currentPage state
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    animation: splashData[index]["animation"],
                    text: splashData[index]['text'],
                    // image: splashData[index]["image"], // Removed as new splashData focuses on animations
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => AnimatedContainer(
                            duration: kAnimationDuration,
                            margin: const EdgeInsets.only(right: 5),
                            height: 6,
                            width: currentPage == index ? 20 : 6,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? const Color(0xFFF40000) : const Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ), 
                      const Spacer(flex: 3),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF40000), // Your primary red color
                          minimumSize: const Size(double.infinity, 50), // Make button wider and taller
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12) // Modern rounded corners
                          )
                        ),
                        onPressed: () {
                          if (currentPage == splashData.length - 1) {
                            // If it's the last page, navigate to SignInScreen
                            Navigator.pushNamed(context, SignInScreen.routeName);
                          } else {
                            // Otherwise, go to the next page
                            _pageController.nextPage(
                              duration: kAnimationDuration, // Use your existing animation duration
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          currentPage == splashData.length - 1 ? "Get Started" : "Next",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
