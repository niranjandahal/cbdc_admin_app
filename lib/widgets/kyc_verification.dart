import 'package:flutter/material.dart';

class KYCVerification extends StatelessWidget {
  final List<Map<String, String>> pendingKYC = [
    {"name": "John Doe", "id": "KYC123"},
    {"name": "Alice Smith", "id": "KYC124"},
    {"name": "Bob Johnson", "id": "KYC125"},
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
            Text("Pending KYC Approvals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Column(
              children: pendingKYC.map((user) {
                return ListTile(
                  title: Text(user["name"]!),
                  subtitle: Text("KYC ID: ${user["id"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.check, color: Colors.green), onPressed: () {}),
                      IconButton(icon: Icon(Icons.close, color: Colors.red), onPressed: () {}),
                    ],
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
