import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Info
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(user?.email ?? "No Email"),
              subtitle: Text("User ID: ${user?.uid ?? "N/A"}"),
            ),

            const SizedBox(height: 30),

            // Notifications Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18),
                ),
                Switch(
                  value: true, // Default ON
                  onChanged: (val) {
                    // Handle notification toggle
                  },
                ),
              ],
            ),

            const Divider(height: 40),

            // Privacy / Terms
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy / Terms"),
              onTap: () {
                // Open privacy/terms screen later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Coming soon!")),
                );
              },
            ),

            const Spacer(),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                        (route) => false,
                  );
                },
                child: const Text(
                  "LOGOUT",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
