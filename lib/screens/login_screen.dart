import 'package:flutter/material.dart';
import 'nrb_dashboard.dart';
import 'bank_dashboard.dart';

class LoginScreen extends StatelessWidget {
  final bool isNRB;
  LoginScreen({required this.isNRB});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(isNRB ? "NRB Admin Login" : "Bank Admin Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "Username")),
            SizedBox(height: 20),
            TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          isNRB ? NRBDashboard() : BankDashboard()),
                );
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
