// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/gradient_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  void login() async {
    if (phoneCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      showMsg("Fill all fields");
      return;
    }

    setState(() => loading = true);

    try {
      // Using Email as Login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: phoneCtrl.text.trim(), // Email input
        password: passCtrl.text.trim(),
      );

      // Redirect to Home Page after successful login
      Navigator.pushReplacementNamed(context, '/home');

    } on FirebaseAuthException catch (e) {
      showMsg(e.message ?? "Login failed");
    }

    setState(() => loading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : GradientButton(
                text: "SIGN IN",
                onPressed: login,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
