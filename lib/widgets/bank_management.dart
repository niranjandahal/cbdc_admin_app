import 'package:flutter/material.dart';

class BankManagement extends StatelessWidget {
  final List<Map<String, dynamic>> banks = [
    {"name": "Everest Bank", "status": "Active"},
    {"name": "Nepal Investment Bank", "status": "Active"},
    {"name": "Himalayan Bank", "status": "Suspended"},
    {"name": "Global IME Bank", "status": "Active"},
    {"name": "NIC Asia Bank", "status": "Pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Title
            Text(
              "Bank Management",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 10),

            // 📌 Bank List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: banks.length,
              itemBuilder: (context, index) {
                final bank = banks[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(Icons.account_balance, color: Colors.blue),
                    title: Text(bank["name"]),
                    subtitle: Text("Status: ${bank["status"]}",
                        style: TextStyle(
                            color: bank["status"] == "Active"
                                ? Colors.green
                                : bank["status"] == "Suspended"
                                    ? Colors.red
                                    : Colors.orange)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (bank["status"] == "Pending")
                          ElevatedButton(
                            onPressed: () {
                              print("Approving ${bank["name"]}");
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: Text("Approve"),
                          ),
                        if (bank["status"] == "Active")
                          ElevatedButton(
                            onPressed: () {
                              print("Suspending ${bank["name"]}");
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade500),
                            child: Text("Suspend",style: TextStyle(color: Colors.white),),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
