import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/bankprovider.dart';

class BankManagement extends StatefulWidget {
  @override
  State<BankManagement> createState() => _BankManagementState();
}

class _BankManagementState extends State<BankManagement> {
  @override
  void initState() {
    super.initState();
    Provider.of<BankProvider>(context, listen: false).fetchAllBanks();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankProvider>(
      builder: (context, provider, child) {
        final banks = provider.banks;
        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bank Management",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(),
                SizedBox(height: 10),
                banks.isEmpty
                    ? Text("No banks found.")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: banks.length,
                        itemBuilder: (context, index) {
                          final bank = banks[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: Icon(Icons.account_balance,
                                  color: Colors.blue),
                              title: Text(bank["name"] ?? ""),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
