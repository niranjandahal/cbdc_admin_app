import 'package:cbdc_admin/widgets/transcation_list.dart';
import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/kyc_verification.dart';
import '../widgets/user_management.dart';
import '../widgets/chart.dart';

class BankDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bank Dashboard")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          // ✅ Wrap in ScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📌 1. Statistics Section
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  StatCard(
                    title: "CBDC Balance",
                    value: "500,000",
                    icon: Icons.balance,
                  ),
                  StatCard(
                    title: "Bank Transactions",
                    value: "300",
                    icon: Icons.money,
                  ),
                  StatCard(
                    title: "Total Users",
                    value: "1200",
                    icon: Icons.person,
                  ),
                  StatCard(
                      title: "KYC Pending",
                      value: "25",
                      icon: Icons.verified_user_sharp),
                ],
              ),
              SizedBox(height: 20),

              // 📌 2. Transaction Chart
              Container(
                height: 400,
                child: TransactionChart(),
              ),
              SizedBox(height: 20),

              // 📌 3. KYC Verification Panel
              KYCVerification(),

              // 📌 4. User Management Panel
              UserManagement(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
