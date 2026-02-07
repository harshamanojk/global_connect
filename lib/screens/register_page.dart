// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:global_connect/components/IdTemplatePage.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/gradient_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Country? selectedCountry;
  bool agree = false;
  bool showPassword = false;

  void submit() async {
    if (nameCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        selectedCountry == null ||
        !agree) {
      showMsg("Please complete all fields");
      return;
    }

    // Navigate to ID Template page
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const IdTemplatePage(),
      ),
    );

    if (result == true) {
      setState(() {});

      try {
        // 1️⃣ Create Firebase Auth user
        UserCredential userCred =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passCtrl.text.trim(),
        );

        // 2️⃣ Save additional info to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCred.user!.uid)
            .set({
          'name': nameCtrl.text.trim(),
          'email': emailCtrl.text.trim(),
          'phone': "+${selectedCountry!.phoneCode} ${phoneCtrl.text.trim()}",
          'country': selectedCountry!.name,
          'createdAt': FieldValue.serverTimestamp(),
        });

        showMsg("Registration successful! Please login.");

        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        showMsg(e.message ?? "Registration failed");
      } catch (e) {
        showMsg("Something went wrong");
      }
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            field("Name", Icons.person, nameCtrl),
            const SizedBox(height: 16),
            countryPicker(),
            const SizedBox(height: 16),
            phoneField(),
            const SizedBox(height: 16),
            field("Email", Icons.email, emailCtrl,
                type: TextInputType.emailAddress),
            const SizedBox(height: 16),
            passwordField(),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: agree,
                  onChanged: (v) => setState(() => agree = v ?? false),
                ),
                const Expanded(child: Text("I agree to Terms & Policy")),
              ],
            ),
            const SizedBox(height: 20),
            GradientButton(text: "REGISTER", onPressed: submit),
          ],
        ),
      ),
    );
  }

  Widget field(String label, IconData icon, TextEditingController ctrl,
      {bool pass = false, TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      obscureText: pass,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget passwordField() {
    return TextField(
      controller: passCtrl,
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => showPassword = !showPassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget phoneField() {
    return TextField(
      controller: phoneCtrl,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Phone",
        prefixIcon: const Icon(Icons.phone),
        prefixText:
        selectedCountry == null ? "" : "+${selectedCountry!.phoneCode} ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget countryPicker() {
    return GestureDetector(
      onTap: () {
        showCountryPicker(
          context: context,
          onSelect: (c) => setState(() => selectedCountry = c),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (selectedCountry != null) Text(selectedCountry!.flagEmoji),
            const SizedBox(width: 10),
            Text(selectedCountry == null
                ? "Select Country"
                : "${selectedCountry!.name} (+${selectedCountry!.phoneCode})"),
            const Spacer(),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
