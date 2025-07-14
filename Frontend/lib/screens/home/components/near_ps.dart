import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

import 'package:nariii_new/features/police_finder/models/police_station_model.dart';

class SpecialOffersWrapper extends StatefulWidget {
  const SpecialOffersWrapper({super.key});

  @override
  State<SpecialOffersWrapper> createState() => _SpecialOffersWrapperState();
}

class _SpecialOffersWrapperState extends State<SpecialOffersWrapper> {
  List<PoliceStation> policeStations = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchStationsWithLocation();
  }

  Future<void> fetchStationsWithLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      double lat = position.latitude;
      double lon = position.longitude;
      final stations = await fetchPoliceStations(lat, lon);
      setState(() {
        policeStations = stations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Location Error: $e";
        isLoading = false;
      });
    }
  }

  Future<List<PoliceStation>> fetchPoliceStations(double lat, double lon) async {
    final dio = Dio();
    final url = 'https://overpass-api.de/api/interpreter';

    final query = """
[out:json];
(
  node["amenity"="police"](around:10000,$lat,$lon);
  way["amenity"="police"](around:10000,$lat,$lon);
  relation["amenity"="police"](around:10000,$lat,$lon);
);
out center;
""";

    final response = await dio.post(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'NariiiSafetyApp/1.0 (youremail@example.com)', // replace with your actual email
        },
      ),
      data: {'data': query},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch data from Overpass API');
    }

    final data = response.data;
    final elements = data['elements'] as List;

    return elements
        .where((element) =>
            (element['lat'] != null || element['center']?['lat'] != null) &&
            (element['lon'] != null || element['center']?['lon'] != null))
        .map<PoliceStation>((element) {
      final name = element['tags']?['name'] ?? 'Unnamed Police Station';
      final latVal = element['lat'] ?? element['center']?['lat'];
      final lonVal = element['lon'] ?? element['center']?['lon'];

      final distance = Geolocator.distanceBetween(lat, lon, latVal, lonVal);

      return PoliceStation(
        name: name,
        lat: latVal,
        lon: lonVal,
        distance: distance,
      );
    })
    .where((station) => station != null && station.distance <= 10000)
    .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
  }

  void _openMap(PoliceStation station) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${station.lat},${station.lon}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null || policeStations.isEmpty) {
      return const Center(
        child: Text(
          'No police stations found nearby.',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return SpecialOffers(
      policeStations: policeStations,
      onNavigateToMap: _openMap, // Pass the function here
    );
  }
}

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    this.title = "Nearest Police Stations",
    this.onMoreTap,
    required this.policeStations,
    this.onNavigateToMap,
    super.key,
  });

  final String title;
  final VoidCallback? onMoreTap;
  final List<PoliceStation> policeStations;
  final void Function(PoliceStation)? onNavigateToMap;

  static const Color _primaryRed = Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryRed, _primaryRed.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 6),
                blurRadius: 16,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (onMoreTap != null)
                        TextButton(
                          onPressed: onMoreTap,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                          ),
                          child: const Text("See All"),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (policeStations.isEmpty)
                    const Text(
                      'No police stations found nearby.',
                      style: TextStyle(color: Colors.white),
                    )
                  else ...policeStations.take(4).toList().asMap().entries.map((entry) {
                    int idx = entry.key;
                    final station = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: idx < 3 ? 12 : 0, // Only 4 items, so idx < 3
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: _InfoItem(
                            icon: Icons.local_police,
                            // Show only the first two parts of the name/address
                            title: station.name.split(',').take(2).join(','),
                            value: '${(station.distance / 1000).toStringAsFixed(2)} km away',
                            primaryColor: _primaryRed,
                            onNavigate: onNavigateToMap != null ? () => onNavigateToMap!(station) : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color primaryColor;
  final VoidCallback? onNavigate;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.primaryColor,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          radius: 24,
          child: Icon(icon, color: primaryColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, // Now this is the actual police station name
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: onNavigate,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.navigation, size: 20, color: primaryColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
