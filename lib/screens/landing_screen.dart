import 'package:flutter/material.dart';
import 'login_screen.dart';

class Landing_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to CBDC Admin", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(isNRB: true)));
              },
              child: Text("Login as NRB Admin"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(isNRB: false)));
              },
              child: Text("Login as Bank Admin"),
            ),
          ],
        ),
      ),
    );
  }
}
