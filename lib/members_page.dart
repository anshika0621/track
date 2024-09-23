import 'package:flutter/material.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
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
    filteredMembers = members; // Show all members initially
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredMembers = members
          .where((member) => member['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void showMembersStartingWith(String letter) {
    setState(() {
      filteredMembers = members
          .where((member) => member['name']!.startsWith(letter))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Members'),
      ),
      body: Row(
        children: [
          // Member List
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Members',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
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
                          backgroundImage: NetworkImage(filteredMembers[index]['image']!),
                        ),
                        title: Text(filteredMembers[index]['name']!),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Alphabet List on the right side
          Container(
            width: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(26, (index) {
                String letter = String.fromCharCode(index + 65); // A-Z
                return GestureDetector(
                  onTap: () => showMembersStartingWith(letter),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
