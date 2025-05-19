import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/bankprovider.dart';

class SendMoneyToUser extends StatefulWidget {
  const SendMoneyToUser({super.key});

  @override
  State<SendMoneyToUser> createState() => _SendMoneyToUserState();
}

class _SendMoneyToUserState extends State<SendMoneyToUser> {
  String? selectedUserId;
  int? amount;
  String description = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<BankProvider>(context, listen: false).fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final bankProvider = Provider.of<BankProvider>(context);
    final users = bankProvider.users;
    final bankId = bankProvider.bankid;
    final cbdcBalance = bankProvider.bankbalance;

    return Scaffold(
      appBar: AppBar(title: Text("Send Money to User")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedUserId,
              hint: Text("Select User"),
              items: users.map((user) {
                return DropdownMenuItem<String>(
                  value: user["_id"],
                  child: Text(user["name"] ?? ""),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedUserId = val;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Amount (CBDC Balance: $cbdcBalance)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                amount = int.tryParse(val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Description (optional)",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                description = val;
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (selectedUserId == null ||
                          amount == null ||
                          amount! <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Please select a user and enter a valid amount.")),
                        );
                        return;
                      }
                      if (amount! > cbdcBalance) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Insufficient CBDC balance.")),
                        );
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      await bankProvider.sendMoneyToUser(
                        bankId: bankId,
                        userId: selectedUserId!,
                        amount: amount!,
                        description: description,
                        context: context,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    },
              child: isLoading ? CircularProgressIndicator() : Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
