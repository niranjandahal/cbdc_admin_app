import 'package:cbdc_admin/provider/bankprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/bank_dashboard.dart';

class UserManagement extends StatefulWidget {
  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
//fetcht the user in the init state

  @override
  void initState() {
    super.initState();
    print("init state called for user management");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BankProvider>(context, listen: false).fetchAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankProvider>(
      builder: (context, userProvider, child) {
        final users = userProvider.users;
        return Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User Management",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                users.isEmpty
                    ? Text("No users found.")
                    : Column(
                        children: users.map((user) {
                          return ListTile(
                            title: Text(user["name"] ?? ""),
                            subtitle:
                                Text("Status: ${user["status"] ?? "Unknown"}"),
                            trailing: IconButton(
                              icon: Icon(Icons.block, color: Colors.red),
                              onPressed: user["status"] == "Blocked"
                                  ? null
                                  : () async {
                                      await Provider.of<BankProvider>(context,
                                              listen: false)
                                          .blockUser(context, user["_id"]);
                                      // Refresh dashboard after blocking
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BankDashboard()),
                                      );
                                    },
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
