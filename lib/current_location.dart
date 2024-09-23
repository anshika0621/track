import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  LatLng? currentLocation; // To store the user's current location
  MapController mapController = MapController(); // Controller to manage the map

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get live location when the widget is initialized
  }

  // Function to get the user's current location
  Future<void> _getCurrentLocation() async {
    // Get the current location
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      // Set the current location
      currentLocation = LatLng(position.latitude, position.longitude);

      // Move the map to the current location
    });
    Future.delayed(Duration(
      seconds: 3,
    )).then((v) {
      setState(() {
        mapController.move(currentLocation!, 13.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Driver Name"),
      ),
      body: currentLocation == null
          ? const Center(
          child:
          CircularProgressIndicator()) // Show loading indicator while waiting for location
          : FlutterMap(
        mapController:
        mapController, // Use the map controller to move the map
        options: MapOptions(
          initialCenter:
          currentLocation!, // Center the map on the current location
          initialZoom: 100.0, // Initial zoom level
        ),
        children: [
          TileLayer(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point:
                currentLocation!, // Place the marker at the live location
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}