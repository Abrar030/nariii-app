import 'package:flutter/material.dart';
import 'package:nariii_new/settings/screens/settings_screen.dart'; // Import the SettingsScreen
import 'package:nariii_new/news/screens/news_screen.dart'; // Import the NewsScreen
import '../../../notification/screens/notificaton_screen.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 16),

          // Styled Icon for "News" to match IconBtnWithCounter appearance
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsScreen()),
              );
            },
            borderRadius: BorderRadius.circular(
              23,
            ), // Half of 46 for circular ripple
            child: Tooltip(
              message: "News",
              child: Container(
                height: 46, // Matches typical IconBtnWithCounter size
                width: 46, // Matches typical IconBtnWithCounter size
                padding: const EdgeInsets.all(
                  12,
                ), // Matches typical IconBtnWithCounter padding
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(
                    0.1,
                  ), // Standard background
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.article_outlined,
                  size:
                      22, // Calculated to fit: 46 (container) - 2 * 12 (padding) = 22
                  // Icon color will be inherited from IconTheme, or you can set it explicitly:
                  // color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: 3,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          IconBtnWithCounter(
            svgSrc:
                "assets/icons/Settings.svg", // Assuming you have a settings icon SVG
            // Or use a Material icon:
            // iconData: Icons.settings_outlined,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
