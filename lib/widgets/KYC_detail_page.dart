import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/bankprovider.dart';

class KYCDetailPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const KYCDetailPage({required this.userData});

  @override
  Widget build(BuildContext context) {
    final bankProvider = Provider.of<BankProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("KYC Details")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("👤 Basic Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              Text("Full Name: ${userData['name']}"),
              Text("Email: ${userData['email']}"),
              Text("Date of Birth: ${userData['dateOfBirth']}"),
              Text("Gov. ID Number: ${userData['governmentIdNumber']}"),
              Text("Wallet Balance: Rs. ${userData['balance']}"),
              Text("User Role: ${userData['role']}"),
              Text("Account Created: ${userData['createdAt']}"),
              SizedBox(height: 20),
              Text("🧑 User Photo",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildImageFromBuffer(userData['profilePhoto']),
              SizedBox(height: 30),
              Text("🪪 Citizenship Document",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildImageFromBuffer(userData['governmentId']),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text("Approve"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      await bankProvider.approveKYC(
                        context,
                        userData['_id'],
                      );
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.close),
                    label: Text("Reject"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      await bankProvider.rejectKYC(
                        context,
                        userData['_id'],
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageFromBuffer(dynamic photoData) {
    if (photoData == null ||
        photoData['data'] == null ||
        photoData['data']['data'] == null) {
      return _placeholderImage("No profile photo available.");
    }

    try {
      final List<dynamic> byteList = photoData['data']['data'];
      final Uint8List uint8list = Uint8List.fromList(byteList.cast<int>());
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          uint8list,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      return _placeholderImage("Failed to load photo.");
    }
  }

  Widget _placeholderImage(String text) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[300],
      child: Center(
        child: Text(text, style: TextStyle(color: Colors.black54)),
      ),
    );
  }
}
