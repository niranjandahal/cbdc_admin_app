import 'package:cbdc_admin/provider/bankprovider.dart';
import 'package:cbdc_admin/screens/sendmoneytobank.dart';
import 'package:cbdc_admin/widgets/transcation_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/chart.dart';
import '../widgets/bank_management.dart';

class NRBDashboard extends StatefulWidget {
  @override
  State<NRBDashboard> createState() => _NRBDashboardState();
}

class _NRBDashboardState extends State<NRBDashboard> {
  final TextEditingController _mintAmountController = TextEditingController();
  bool _isMinting = false;
  @override
  void initState() {
    super.initState();
    Provider.of<BankProvider>(context, listen: false).getNRBStats();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankProvider>(builder: (context, provider, child) {
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
                    GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Sendmoneytobank(),
                            )),
                        child: StatCard(
                            title: "Send Money", value: "", icon: Icons.send)),
                    StatCard(
                        title: "Total CBDC Minted",
                        value: provider.nrbTotalMinted.toString(),
                        icon: Icons.account_balance_wallet),
                    StatCard(
                        title: "Balance ",
                        value: provider.nrbBalance.toString(),
                        icon: Icons.account_balance_wallet),
                    StatCard(
                        title: "Total Transfers",
                        value: provider.nrbTotalTransfer.toString(),
                        icon: Icons.swap_horiz),
                    StatCard(
                        title: "Total Banks",
                        value: provider.nrbTotalBanks.toString(),
                        icon: Icons.business),
                  ],
                ),

                SizedBox(height: 20),

                // 📌 2. Minting Section

                // 📌 2. Minting Section
                Card(
                  child: Container(
                    height: 170,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
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
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _mintAmountController,
                                decoration: InputDecoration(
                                  labelText: "Amount",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: _isMinting
                                  ? null
                                  : () async {
                                      final amount = int.tryParse(
                                          _mintAmountController.text);
                                      if (amount == null || amount <= 0) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Enter a valid amount.")),
                                        );
                                        return;
                                      }
                                      setState(() {
                                        _isMinting = true;
                                      });
                                      final provider =
                                          Provider.of<BankProvider>(context,
                                              listen: false);
                                      await provider.mintCBDC(context, amount);
                                      setState(() {
                                        _isMinting = false;
                                      });
                                      _mintAmountController.clear();
                                    },
                              child: _isMinting
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white),
                                    )
                                  : Text("Mint"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // ...rest of your dashboard...
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
                // Card(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   elevation: 3,
                //   child: KYCVerification(),
                // ),
                // SizedBox(height: 20),

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
                // Card(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   elevation: 3,
                //   child: SizedBox(
                //     height: 300,
                //     child: TransactionList(),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
