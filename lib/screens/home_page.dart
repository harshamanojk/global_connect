import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'emergency_bot_page.dart';
import '../data/emergency_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void makeCall(BuildContext context, String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot make a call to $number')),
      );
    }
  }

  void showCountryCallDialog(BuildContext context) {
    final TextEditingController countryCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Country for Emergency Call'),
          content: TextField(
            controller: countryCtrl,
            decoration: const InputDecoration(
              hintText: "Enter country name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String input = countryCtrl.text.trim();
                if (input.isEmpty) return;

                String formatted =
                    input[0].toUpperCase() + input.substring(1).toLowerCase();

                if (emergencyNumbers.containsKey(formatted)) {
                  Navigator.pop(context);

                  Map<String, String> numbers = emergencyNumbers[formatted]!;

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Emergency Numbers for $formatted'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: numbers.entries.map((entry) {
                          return ListTile(
                            title: Text('${entry.key}: ${entry.value}'),
                            trailing: const Icon(Icons.call),
                            onTap: () => makeCall(context, entry.value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Country not found')),
                  );
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GlobalConnect Home"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Welcome to GlobalConnect!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Quick Access:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.health_and_safety, size: 28),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  "Emergency Bot",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmergencyBotPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.phone, size: 28),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  "Emergency Call",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => showCountryCallDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
