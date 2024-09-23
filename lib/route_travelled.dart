import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:untitled/config/api_key.dart';

class RouteMap extends StatefulWidget {
  @override
  _RouteMapState createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  // Coordinates for the routes
  final LatLng startPoint = const LatLng(28.6139, 77.2090); // Delhi, India
  final LatLng endPoint1 = const LatLng(27.1767, 78.0081); // Agra, India
  final LatLng endPoint2 = const LatLng(30.3165, 78.0322); // Dehradun, India

  List<LatLng> routePoints = []; // Points for the current route being displayed
  String errorMessage = ''; // Error message, if any
  bool isLoading = true; // To show loading state
  String duration1 = ''; // Duration for route 1
  String distance1 = ''; // Distance for route 1
  String duration2 = ''; // Duration for route 2
  String distance2 = ''; // Distance for route 2
  int?
  selectedRoute; // To track the selected route (0 for Agra, 1 for Dehradun)

  @override
  void initState() {
    super.initState();
    // Fetch both routes on initialization to show details in ListTile
    fetchRoute(startPoint, endPoint1, isRouteDetailsOnly: true);
    fetchRoute(startPoint, endPoint2, isRouteDetailsOnly: true);
  }

  // Function to fetch route from OpenRouteService API
  Future<void> fetchRoute(LatLng start, LatLng end,
      {bool isRouteDetailsOnly = false}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=${ApiKey.api}&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coordinates =
        data['features'][0]['geometry']['coordinates'] as List;
        final duration =
        data['features'][0]['properties']['segments'][0]['duration'];
        final distance =
        data['features'][0]['properties']['segments'][0]['distance'];

        // Convert duration and distance to readable format
        final durationStr = formatDuration(duration);
        final distanceStr = formatDistance(distance);

        if (isRouteDetailsOnly) {
          // Update duration and distance for the respective route
          setState(() {
            if (end == endPoint1) {
              duration1 = durationStr;
              distance1 = distanceStr;
            } else if (end == endPoint2) {
              duration2 = durationStr;
              distance2 = distanceStr;
            }
            isLoading = false;
          });
        } else {
          // Decode the coordinates and convert them to LatLng
          List<LatLng> points = coordinates.map((coord) {
            return LatLng(coord[1], coord[0]);
          }).toList();

          setState(() {
            routePoints = points;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load route.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  // Format duration in seconds to hours and minutes
  String formatDuration(double durationInSeconds) {
    int minutes = (durationInSeconds / 60).round();
    int hours = minutes ~/ 60;
    minutes = minutes % 60;
    return hours > 0 ? '$hours hrs $minutes mins' : '$minutes mins';
  }

  // Format distance in meters to kilometers
  String formatDistance(double distanceInMeters) {
    double kilometers = distanceInMeters / 1000;
    return '${kilometers.toStringAsFixed(2)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Name : Route Travelled')),
      body: Column(
        children: [
          // Map Section at the Top
          Expanded(
            flex: 3,
            child: FlutterMap(
              options: MapOptions(
                initialCenter:
                startPoint, // Center the map at the starting point
                initialZoom: 7.0,
              ),
              children: [
                // Base map layer
                TileLayer(
                  urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                // PolylineLayer to show the route
                if (!isLoading && routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                // Simple Markers for start and end points
                MarkerLayer(
                  markers: [
                    Marker(
                      point: startPoint,
                      child: Container(
                        child: const Column(
                          children: [
                            Icon(Icons.location_on, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                    Marker(
                      point: endPoint1,
                      child: Container(
                        child: const Column(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                    Marker(
                      point: endPoint2,
                      child: Container(
                        child: const Column(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Error Message if any
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          // Loading Indicator
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          // ListTiles to switch between routes
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ListTile(
                  title: const Text('Route to Agra'),
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Start Point: ',
                          style: TextStyle(color: Colors.green),
                        ),
                        TextSpan(
                          text: 'Delhi ',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'End Point: ',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: 'Agra ',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '\nDuration: $duration1, Distance: $distance1',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  tileColor: selectedRoute == 0 ? Colors.lightBlueAccent : null,
                  onTap: () {
                    setState(() {
                      selectedRoute = 0; // Select Agra route
                    });
                    fetchRoute(startPoint, endPoint1); // Load first route
                  },
                ),
                ListTile(
                  title: const Text('Route to Dehradun'),
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Start Point: ',
                          style: TextStyle(color: Colors.green),
                        ),
                        TextSpan(
                          text: 'Delhi ',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'End Point: ',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: 'Dehradun ',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '\nDuration: $duration2, Distance: $distance2',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  tileColor: selectedRoute == 1 ? Colors.lightBlueAccent : null,
                  onTap: () {
                    setState(() {
                      selectedRoute = 1; // Select Dehradun route
                    });
                    fetchRoute(startPoint, endPoint2); // Load second route
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
