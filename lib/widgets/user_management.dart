import 'package:flutter/material.dart';

class UserManagement extends StatelessWidget {
  final List<Map<String, String>> users = [
    {"name": "John Doe", "status": "Active"},
    {"name": "Alice Smith", "status": "Blocked"},
    {"name": "Bob Johnson", "status": "Pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User Management", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Column(
              children: users.map((user) {
                return ListTile(
                  title: Text(user["name"]!),
                  subtitle: Text("Status: ${user["status"]}"),
                  trailing: IconButton(
                    icon: Icon(Icons.block, color: Colors.red),
                    onPressed: () {},
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
