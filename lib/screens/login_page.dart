// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/gradient_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  // Show / Hide Password
  bool obscurePassword = true;

  // Remember Me
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  // Auto Login
  void autoLogin() async {

    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // Save Login
  void saveLogin() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', true);
  }

  // Login Function
  void login() async {

    final email = emailCtrl.text.trim();
    final password = passCtrl.text.trim();

    // Validation
    if (email.isEmpty || password.isEmpty) {
      showMsg("Fill all fields");
      return;
    }

    if (password.length < 6) {
      showMsg("Password must be at least 6 characters");
      return;
    }

    setState(() => loading = true);

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save if Remember Me checked
      if (rememberMe) {
        saveLogin();
      }

      Navigator.pushReplacementNamed(context, '/home');

    } on FirebaseAuthException catch (e) {

      showMsg(e.message ?? "Login failed");

    }

    setState(() => loading = false);
  }

  // Forgot Password
  void forgotPassword() async {

    final email = emailCtrl.text.trim();

    if (email.isEmpty) {
      showMsg("Enter your email first");
      return;
    }

    try {

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email);

      showMsg("Reset link sent to your email");

    } catch (e) {

      showMsg("Error sending reset email");

    }
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

      body: SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.all(24),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const SizedBox(height: 40),

              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Email
              TextField(
                controller: emailCtrl,

                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password
              TextField(

                controller: passCtrl,

                obscureText: obscurePassword,

                decoration: InputDecoration(

                  labelText: "Password",

                  prefixIcon: const Icon(Icons.lock),

                  suffixIcon: IconButton(

                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),

                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Remember Me + Forgot
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  Row(
                    children: [

                      Checkbox(
                        value: rememberMe,

                        onChanged: (val) {
                          setState(() {
                            rememberMe = val!;
                          });
                        },
                      ),

                      const Text("Remember Me"),
                    ],
                  ),

                  TextButton(
                    onPressed: forgotPassword,
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,

                child: loading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : GradientButton(
                  text: "SIGN IN",
                  onPressed: login,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
