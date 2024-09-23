import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled/current_location.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 24,
          ),
          onPressed: () {},
        ),
        title: const Text("Attendance"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.3),
                      child: const Icon(Icons.people),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("All members")
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    child: const Icon(Icons.person),
                  ),
                  title: const Text("Driver Name : Current Location"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RouteMap()),
                          );
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                      IconButton(
                        onPressed: () {
                          getLocation(context);
                        },
                        icon: const Icon(Icons.my_location),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getLocation(BuildContext context) async {
    // Check and request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Handle case where permission is denied or denied forever
        _showSnackBar(context, 'Location Permission denied!');
        return;
      }
    }

    // Check if permission is granted
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar(
            context, 'Please enable location! Opening Location Settings');
        await Geolocator.openLocationSettings();
        // Re-check if the user enabled location services
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          _showSnackBar(context, 'Location access denied! Please try again.');
          return;
        }
      }

      // If everything is fine, navigate to the current location screen
      _navigateToCurrentLocation(context);
    } else {
      // Fallback for permissions that are still not granted
      _showSnackBar(context, 'Location Permission denied!');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _navigateToCurrentLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CurrentLocation()),
    );
  }
}
