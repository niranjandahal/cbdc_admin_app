import 'package:cbdc_admin/widgets/transcation_list.dart';
import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/chart.dart';
import '../widgets/kyc_verification.dart';
import '../widgets/bank_management.dart';

class NRBDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NRB Dashboard")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📌 1. Overview Statistics
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  StatCard(title: "Total CBDC Minted", value: "1,000,000"),
                  StatCard(title: "Total Transactions", value: "500"),
                  StatCard(title: "Total Banks", value: "15"),
                  StatCard(title: "KYC Pending", value: "30"),
                ],
              ),
              SizedBox(height: 20),

              // 📌 2. Minting Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mint New CBDC",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Amount",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            print("Minting CBDC...");
                          },
                          child: Text("Mint"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // 📌 3. CBDC Volume Chart
              Container(
                height: 200,
                child: Chart(),
              ),
              SizedBox(height: 20),

              // 📌 4. KYC Verification Panel
              KYCVerification(),

              // 📌 5. Bank Management Panel
              BankManagement(),

              SizedBox(height: 20),

              // 📌 6. Recent Transactions Table
              SizedBox(
                height: 300,
                child: TransactionList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
