import 'package:cbdc_admin/provider/bankprovider.dart';
import 'package:cbdc_admin/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nrb_dashboard.dart';

class LoginScreen extends StatefulWidget {
  final bool isNRB;
  LoginScreen({required this.isNRB});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  void _handleLogin(BuildContext context) async {
    final email = usernameController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (widget.isNRB) {
      // if the username is nrb and password is nrbnepal123 then naviagate to dashboard.
      if (email == "nrb" && password == "nrbnepal123") {
        // Navigate to NRB Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NRBDashboard()),
        );
        return;
      }
    } else {
      try {
        final bankProvider = Provider.of<BankProvider>(context, listen: false);
        await bankProvider.banklogin(context, email, password);
      } catch (e) {
        print("Login failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: $e")),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isNRB ? "NRB Admin Login" : "Bank Admin Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _handleLogin(context),
                    child: Text("Login"),
                  ),
            SizedBox(height: 20),
            widget.isNRB
                ? Container()
                : TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                    child: Text("Do a bank registration"),
                  ),
          ],
        ),
      ),
    );
  }
}