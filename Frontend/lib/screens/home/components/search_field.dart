import 'package:flutter/material.dart';

import '../../../news/screens/news_screen.dart';
import '../../../settings/screens/settings_screen.dart';
import '../../../screens/profile/screens/account_screen.dart';
import '../../../community/screens/community_screen.dart';
import 'contacts.dart';
import '../../../sos/screens/emergency_history_screen.dart';

import '../../../constants.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();
  final List<_SearchItem> _allItems = [
    _SearchItem(
      title: "News",
      icon: Icons.newspaper,
      screen: const NewsScreen(),
    ),
    _SearchItem(
      title: "Settings",
      icon: Icons.settings,
      screen: const SettingsScreen(),
    ),
    _SearchItem(
      title: "Account",
      icon: Icons.person,
      screen: const AccountScreen(),
    ),
    _SearchItem(
      title: "Communities",
      icon: Icons.groups,
      screen: const CommunityListScreen(),
    ),
    _SearchItem(
      title: "Contacts",
      icon: Icons.contacts,
      screen: const ContactsSection(),
    ),
    _SearchItem(
      title: "Emergency History",
      icon: Icons.history,
      screen: const EmergencyHistoryScreen(),
    ),
  ];

  List<_SearchItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems
          .where((item) => item.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => _SearchOverlay(
            allItems: _allItems,
          ),
        );
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: kSecondaryColor.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            border: searchOutlineInputBorder,
            focusedBorder: searchOutlineInputBorder,
            enabledBorder: searchOutlineInputBorder,
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}

// Overlay widget
class _SearchOverlay extends StatefulWidget {
  final List<_SearchItem> allItems;
  const _SearchOverlay({required this.allItems});

  @override
  State<_SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<_SearchOverlay> {
  late List<_SearchItem> _filteredItems;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.allItems;
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filteredItems = widget.allItems
          .where((item) => item.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDropdownHeight = MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kSecondaryColor.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  border: searchOutlineInputBorder,
                  focusedBorder: searchOutlineInputBorder,
                  enabledBorder: searchOutlineInputBorder,
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(child: Text("No results found"))
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 0,
                        color: Colors.grey[200],
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pop(context); // Close overlay
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: item.builder),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: kPrimaryRed.withOpacity(0.12),
                                    radius: 18,
                                    child: Icon(item.icon, color: kPrimaryRed, size: 18),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchItem {
  final String title;
  final IconData icon;
  final WidgetBuilder builder;

  _SearchItem({
    required this.title,
    required this.icon,
    required Widget screen,
  }) : builder = ((context) => screen);
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);
