import 'package:flutter/material.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  // List of members with names and corresponding image URLs
  final List<Map<String, String>> members = [
    {'name': 'Jyoti', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Anshika', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Mehak', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Gaurav', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Saurabh', 'image': 'https://via.placeholder.com/150'},
  ];

  List<Map<String, String>> filteredMembers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredMembers = members; // Initially show all members
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredMembers = members
          .where((member) => member['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Members',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search), // Add search icon here
              ),
              onChanged: updateSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(filteredMembers[index]['image']!), // Profile image
                  ),
                  title: Text(filteredMembers[index]['name']!), // Member name
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}