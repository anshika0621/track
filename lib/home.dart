import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:track1/current_location.dart';
import 'package:track1/route_travelled.dart';
import 'package:track1/members_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // List of driver details with call types and times
  final List<Map<String, String>> driverDetails = [
    {'name': 'Anshika', 'outgoingTime': '10:30 AM', 'incomingTime': '09:15 AM'},
    {'name': 'Jyoti', 'outgoingTime': '11:00 AM', 'incomingTime': '10:00 AM'},
    {'name': 'Mehak', 'outgoingTime': '09:15 AM', 'incomingTime': '08:45 AM'},
    {'name': 'Gaurav', 'outgoingTime': '12:45 PM', 'incomingTime': '11:30 AM'},
    {'name': 'Saurabh', 'outgoingTime': '03:30 PM', 'incomingTime': '02:00 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 24),
          onPressed: () {},
        ),
        title: const Text("Attendance"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey, // Set background color to light grey
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to MembersPage when "All members" is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MembersPage()),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent.withOpacity(0.3),
                        child: const Icon(Icons.people),
                      ),
                      const SizedBox(width: 10),
                      const Text("All members"),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to MembersPage when "Change Name" is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MembersPage()),
                    );
                  },
                  child: const Text("Change", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: driverDetails.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.withOpacity(0.3),
                        child: const Icon(Icons.person),
                      ),
                      title: Text(driverDetails[index]['name']!),
                      subtitle: Row(
                        children: [
                          // Outgoing call
                          Row(
                            children: [
                              const Icon(Icons.call_made, size: 16, color: Colors.green), // Outgoing call icon
                              const SizedBox(width: 5),
                              Text(driverDetails[index]['outgoingTime']!), // Outgoing call time
                            ],
                          ),
                          const SizedBox(width: 20),
                          // Incoming call
                          Row(
                            children: [
                              const Icon(Icons.call_received, size: 16, color: Colors.red), // Incoming call icon
                              const SizedBox(width: 5),
                              Text(driverDetails[index]['incomingTime']!), // Incoming call time
                            ],
                          ),
                        ],
                      ),
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
                          ),
                        ],
                      ),
                    ),
                    // Grey line separator
                    const Divider(color: Colors.grey), // Add this line for separation
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _showSnackBar(context, 'Location Permission denied!');
        return;
      }
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar(context, 'Please enable location! Opening Location Settings');
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          _showSnackBar(context, 'Location access denied! Please try again.');
          return;
        }
      }
      _navigateToCurrentLocation(context);
    } else {
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
      MaterialPageRoute(builder: (context) =>  CurrentLocation()),
    );
  }
}
