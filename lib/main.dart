import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'screens/landing_page.dart';
import 'screens/register_page.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/emergency_bot_page.dart';
import 'screens/emergency_call_page.dart';

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
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/emergencyBot': (context) => const EmergencyBotPage(),
        '/emergencyCall': (context) => const EmergencyCallPage(),
      },
    );
  }
}
