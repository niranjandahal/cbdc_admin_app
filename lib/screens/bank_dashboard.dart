import 'package:cbdc_admin/provider/bankprovider.dart';
import 'package:cbdc_admin/screens/sendmoneytouser.dart';
import 'package:cbdc_admin/widgets/user_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/kyc_verification.dart';
import '../widgets/chart.dart';

class BankDashboard extends StatefulWidget {
  @override
  State<BankDashboard> createState() => _BankDashboardState();
}

class _BankDashboardState extends State<BankDashboard> {
  @override
  void initState() {
    super.initState();
    final bankProvider = Provider.of<BankProvider>(context, listen: false);
    final bankId = bankProvider.bankdetailafterlogin?["_id"];
    if (bankId != null) {
      bankProvider.fetchStats(bankId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankProvider>(
      builder: (context, bankProvider, child) {
        return Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                  bankProvider.bankdetailafterlogin!["name"] + "  Dashboard")),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendMoneyToUser()),
                          );
                        },
                        child: StatCard(
                          title: "Send Money ",
                          value: "",
                          icon: Icons.send,
                        ),
                      ),
                      StatCard(
                        title: "CBDC Balance",
                        value: bankProvider.bankbalance.toString(),
                        icon: Icons.balance,
                      ),
                      StatCard(
                        title: "Bank Transactions",
                        value: bankProvider.banktransaction.toString(),
                        icon: Icons.money,
                      ),
                      StatCard(
                        title: "Total Users",
                        value: bankProvider.totaluser.toString(),
                        icon: Icons.person,
                      ),
                      StatCard(
                        title: "KYC Pending",
                        value: bankProvider.kycpending.toString(),
                        icon: Icons.verified_user_sharp,
                      ),
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
      },
    );
  }
}
