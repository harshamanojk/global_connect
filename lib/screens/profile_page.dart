import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  File? _imageFile;

  String name = "";
  String email = "";
  String country = "";
  String? imageUrl;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  // ================= FETCH =================
  Future<void> fetchUser() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;

      setState(() {
        name = data['name'];
        email = data['email'];
        country = data['country'];
        imageUrl = data['imageUrl'];
        loading = false;
      });
    }
  }

  // ================= PICK IMAGE =================
  Future<void> pickImage() async {
    final picked =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    _imageFile = File(picked.path);

    setState(() => loading = true);

    final ref = FirebaseStorage.instance
        .ref("profiles/${user!.uid}.jpg");

    await ref.putFile(_imageFile!);

    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'imageUrl': url});

    setState(() {
      imageUrl = url;
      loading = false;
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : null,
                child: imageUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            info("Name", name),
            info("Email", email),
            info("Country", country),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoginPage()),
                      (route) => false,
                );
              },
              child: const Text("LOGOUT"),
            ),
          ],
        ),
      ),
    );
  }

  Widget info(String t, String v) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t, style: const TextStyle(color: Colors.grey)),
          Text(v,
              style:
              const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
