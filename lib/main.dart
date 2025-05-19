import 'package:cbdc_admin/provider/bankprovider.dart';
import 'package:cbdc_admin/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    //multiprovider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BankProvider()),
      ],
      child: CBDCAdminApp(),
    ),
  );
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
