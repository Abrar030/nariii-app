import 'package:flutter/material.dart';
import 'community_detail_screen.dart';
import '../screens/community_model.dart';

const Color kPrimaryRed = Color(0xFFF40000);

class CommunityListScreen extends StatefulWidget {
  const CommunityListScreen({super.key});

  @override
  State<CommunityListScreen> createState() => _CommunityListScreenState();
}

class _CommunityListScreenState extends State<CommunityListScreen> {
  final List<Community> communities = [
    Community(
      name: "Local",
      joined: false,
      members: 245,
      image: "assets/images/local_community.png",
    ),
    Community(
      name: "City",
      joined: false,
      members: 512,
      image: "assets/images/city_community.png",
    ),
    Community(
      name: "National",
      joined: false,
      members: 1200,
      image: "assets/images/national_community.png",
    ),
  ];

  void _addCommunity() {
    setState(() {
      communities.add(Community(
        name: "New Community",
        joined: false,
        members: 0,
        image: "assets/images/default_community.png",
      ));
    });
  }

  void _editCommunity(int index) {
    final oldName = communities[index].name;
    setState(() {
      communities[index].name = "$oldName (Edited)";
    });
  }

  @override
  Widget build(BuildContext context) {
    final joinedCommunities = communities.where((c) => c.joined).toList();
    final otherCommunities = communities.where((c) => !c.joined).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Communities",
          style: TextStyle(
            color: Color(0xFFF40000),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF40000)),
      ),
      body: Column(
        children: [
          _buildNewCommunityCard(),
          _buildSearchBar(),
          Expanded(
            child: ListView(
              children: [
                if (joinedCommunities.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Your Communities", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...joinedCommunities.map((c) => _buildCommunityTile(c)),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Discover Communities", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...otherCommunities.map((c) => _buildCommunityTile(c)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewCommunityCard() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: _addCommunity,
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: const [
              CircleAvatar(
                backgroundColor: kPrimaryRed,
                child: Icon(Icons.add, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text("New Community", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search communities",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCommunityTile(Community community) {
    IconData iconData;
    switch (community.name.toLowerCase()) {
      case 'local':
        iconData = Icons.home_work_outlined;
        break;
      case 'city':
        iconData = Icons.location_city;
        break;
      case 'national':
        iconData = Icons.public;
        break;
      default:
        iconData = Icons.group_outlined;
    }

    final isDiscover = !community.joined;
    final tile = Container(
      decoration: BoxDecoration(
        color: isDiscover ? kPrimaryRed.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDiscover ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: kPrimaryRed.withOpacity(0.1),
              child: Icon(iconData, color: kPrimaryRed, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(community.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("${community.members} members", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (community.joined)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: kPrimaryRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("Joined", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            else
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    community.joined = true;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: kPrimaryRed),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Join", style: TextStyle(color: kPrimaryRed, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityDetailScreen(community: community),
          ),
        );
      },
      child: tile,
    );
  }
}
