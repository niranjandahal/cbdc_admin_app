import 'package:cbdc_admin/screens/landing_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CBDCAdminApp());
}

class CBDCAdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //darkmode
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'CBDC Admin',
      home: Landing_screen(),
    );
  }
}
