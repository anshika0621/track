import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled/current_location.dart';
import 'package:untitled/route_travelled.dart';
import 'package:untitled/member_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title and dropdown menu attached to menu icon
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        // PopupMenuButton with icons and block items
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, size: 24), // Menu icon
          onSelected: (value) {
            // Handle navigation based on selected option
            if (value == 'Attendance') {
              // Already on Attendance page, no action needed
            } else if (value == 'Timer') {
              // Navigate to Timer page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with TimerPage
              );
            } else if (value == 'Activity Report') {
              // Navigate to Activity Report page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with ActivityReportPage
              );
            } else if (value == 'Timesheet') {
              // Navigate to Timesheet page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with TimesheetPage
              );
            } else if (value == 'Jobsite') {
              // Navigate to Jobsite page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with JobsitePage
              );
            }
          },
          // Items in the pop-up menu with icons
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'Attendance',
                // Row used to display the icon and text as a block
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_outline, color: Colors.blueAccent), // Attendance icon
                    SizedBox(width: 10), // Space between icon and text
                    Text('Attendance'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Timer',
                child: Row(
                  children: const [
                    Icon(Icons.timer, color: Colors.green), // Timer icon
                    SizedBox(width: 10),
                    Text('Timer'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Activity Report',
                child: Row(
                  children: const [
                    Icon(Icons.report, color: Colors.orange), // Activity report icon
                    SizedBox(width: 10),
                    Text('Activity Report'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Timesheet',
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today, color: Colors.red), // Timesheet icon
                    SizedBox(width: 10),
                    Text('Timesheet'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Jobsite',
                child: Row(
                  children: const [
                    Icon(Icons.work, color: Colors.purple), // Jobsite icon
                    SizedBox(width: 10),
                    Text('Jobsite'),
                  ],
                ),
              ),
            ];
          },
        ),
        title: const Text("Attendance"), // Title of the page
      ),
      // Body of the page remains the same
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white38, // Background color for the container
            ),
            child: GestureDetector(
              onTap: () {
                // Navigate to MembersPage when tapped
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
                  const Text("All members"), // Label for the row
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 2, // Number of list items
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.3),
                    child: const Icon(Icons.person),
                  ),
                  title: const Text("Driver Name: Current Location"), // Placeholder text
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RouteMap()), // Replace with RouteMap
                          );
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                      IconButton(
                        onPressed: () {
                          getLocation(context); // Call getLocation when pressed
                        },
                        icon: const Icon(Icons.my_location),
                      ),
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

  // Method to get the user's location
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

  // Method to show a snackbar with a message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Method to navigate to the current location page
  void _navigateToCurrentLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CurrentLocation()), // Replace with your current location page
    );
  }
}
