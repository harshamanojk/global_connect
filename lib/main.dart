import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:global_connect/screens/login.dart';
import 'firebase_options.dart';
import 'screens/landing_page.dart';
import 'screens/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GlobalConnectApp());
}

class GlobalConnectApp extends StatelessWidget {
  const GlobalConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GlobalConnect',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage()
      },
    );
  }
}
