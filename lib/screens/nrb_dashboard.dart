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
      appBar: AppBar(
        title: Text("NRB Dashboard"),
        centerTitle: true,
        // backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📌 1. Overview Statistics
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                      title: "Total CBDC Minted",
                      value: "1,000,000",
                      icon: Icons.account_balance_wallet),
                  StatCard(
                      title: "Total Transactions",
                      value: "500",
                      icon: Icons.swap_horiz),
                  StatCard(
                      title: "Total Banks", value: "15", icon: Icons.business),
                ],
              ),

              SizedBox(height: 20),

              // 📌 2. Minting Section
              Card(
                child: Container(
                  height: 170,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mint New CBDC",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.monetization_on,
                              color: Colors.green, size: 30),
                        ],
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
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
              ),
              SizedBox(height: 20),

              // 📌 3. CBDC Volume Chart
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(height: 400, child: TransactionChart()),
                ),
              ),
              SizedBox(height: 20),

              // 📌 4. KYC Verification Panel
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: KYCVerification(),
              ),
              SizedBox(height: 20),

              // 📌 5. Bank Management Panel
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: BankManagement(),
              ),
              SizedBox(height: 20),

              // 📌 6. Recent Transactions Table
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: SizedBox(
                  height: 300,
                  child: TransactionList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
