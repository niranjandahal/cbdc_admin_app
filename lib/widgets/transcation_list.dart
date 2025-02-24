import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Map<String, String>> transactions = [
    {"date": "2024-06-01", "amount": "10,000", "status": "Completed"},
    {"date": "2024-06-02", "amount": "5,000", "status": "Pending"},
    {"date": "2024-06-03", "amount": "12,000", "status": "Failed"},
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
            Text("Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Column(
              children: transactions.map((tx) {
                return ListTile(
                  title: Text("Amount: ${tx["amount"]}"),
                  subtitle: Text("Date: ${tx["date"]}"),
                  trailing: Text(tx["status"]!,
                      style: TextStyle(color: Colors.green)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
