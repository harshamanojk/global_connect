import 'package:flutter/material.dart';
import 'screens/landing_page.dart';

void main() {
  runApp(GlobalConnectApp());
}

class GlobalConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlobalConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    );
  }
}
