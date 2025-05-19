import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/bankprovider.dart';

class Sendmoneytobank extends StatefulWidget {
  const Sendmoneytobank({super.key});

  @override
  State<Sendmoneytobank> createState() => _SendmoneytobankState();
}

class _SendmoneytobankState extends State<Sendmoneytobank> {
  String? selectedBankId;
  int? amount;
  String description = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<BankProvider>(context, listen: false).fetchAllBanks();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BankProvider>(context);
    final banks = provider.banks;

    return Scaffold(
      appBar: AppBar(title: Text("Send Money to Bank")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedBankId,
              hint: Text("Select Bank"),
              items: banks.map((bank) {
                return DropdownMenuItem<String>(
                  value: bank["_id"],
                  child: Text(bank["name"] ?? ""),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedBankId = val;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Amount",
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
                      if (selectedBankId == null ||
                          amount == null ||
                          amount! <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Please select a bank and enter a valid amount.")),
                        );
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      await provider.sendMoneyToBank(
                        bankId: selectedBankId!,
                        amount: amount!,
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
