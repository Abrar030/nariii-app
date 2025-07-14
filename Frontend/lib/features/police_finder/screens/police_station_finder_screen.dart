import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nariii_new/features/police_finder/models/police_station_model.dart';

class PoliceStationFinderScreen extends StatefulWidget {
  const PoliceStationFinderScreen({super.key});

  @override
  State<PoliceStationFinderScreen> createState() =>
      _PoliceStationFinderScreenState();
}

class _PoliceStationFinderScreenState extends State<PoliceStationFinderScreen> {
  bool _isLoading = false;
  List<PoliceStation> _policeStations = [];
  String? _errorMessage;

  Future<void> _findNearbyPoliceStations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _policeStations = [];
    });

    try {
      final status = await Permission.location.request();
      if (!status.isGranted) {
        throw Exception(
            'Location permission is required to find nearby police stations.');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final lat = position.latitude;
      final lon = position.longitude;

      final stations = await fetchPoliceStations(lat, lon);

      if (stations.isEmpty) {
        setState(() {
          _errorMessage = 'No police stations found nearby.';
        });
        return;
      }

      setState(() {
        _policeStations = stations;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchMaps(double lat, double lon) async {
    final url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open maps for $lat,$lon')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Police Stations'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _findNearbyPoliceStations,
        tooltip: 'Find Stations',
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: $_errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    if (_policeStations.isEmpty) {
      return const Center(
        child: Text('Press the search button to find nearby police stations.'),
      );
    }

    return ListView.builder(
      itemCount: _policeStations.length,
      itemBuilder: (context, index) {
        final station = _policeStations[index];
        return ListTile(
          leading: const Icon(Icons.local_police),
          title: Text(station.name),
          subtitle:
              Text('${(station.distance / 1000).toStringAsFixed(2)} km away'),
          trailing: IconButton(
            icon: const Icon(Icons.directions),
            onPressed: () => _launchMaps(station.lat, station.lon),
          ),
        );
      },
    );
  }

  Future<List<PoliceStation>> fetchPoliceStations(double lat, double lon) async {
    final url = Uri.parse('https://overpass-api.de/api/interpreter');

    final query = """
[out:json];
(
  node["amenity"="police"](around:5000,$lat,$lon);
  way["amenity"="police"](around:5000,$lat,$lon);
  relation["amenity"="police"](around:5000,$lat,$lon);
);
out center;
""";

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': 'NariiiSafetyApp/1.0 (youremail@example.com)', // replace with your actual email
      },
      body: {'data': query},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch data from Overpass API');
    }

    final data = json.decode(response.body);
    final elements = data['elements'] as List;

    return elements.map<PoliceStation>((element) {
      final name = element['tags']?['name'] ?? 'Unnamed Police Station';
      final latVal = element['lat'] ?? element['center']?['lat'];
      final lonVal = element['lon'] ?? element['center']?['lon'];

      if (latVal == null || lonVal == null) {
        throw Exception('Invalid police station coordinates');
      }

      final distance = Geolocator.distanceBetween(lat, lon, latVal, lonVal);

      return PoliceStation(
        name: name,
        lat: latVal,
        lon: lonVal,
        distance: distance,
      );
    }).whereType<PoliceStation>().toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
  }
}
