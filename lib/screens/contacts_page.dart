import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_connect/components/calling_page.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  final List<String> contacts = const [
    "Alice",
    "Bob",
    "Charlie",
    "David",
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String callerName = user?.email?.split('@')[0] ?? "Me";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          String contact = contacts[index];
          return Card(
            child: ListTile(
              title: Text(contact),
              leading: const Icon(Icons.person),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () {
                  // Navigate to CallingPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallingPage(
                        callerName: callerName,
                        receiverName: contact,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
