import 'package:flutter/material.dart';
import '../data/emergency_data.dart';

class EmergencyBotPage extends StatefulWidget {
  const EmergencyBotPage({super.key});

  @override
  State<EmergencyBotPage> createState() => _EmergencyBotPageState();
}

class _EmergencyBotPageState extends State<EmergencyBotPage> {
  final TextEditingController countryController = TextEditingController();

  Map<String, String>? result;
  String error = "";

  void searchCountry() {
    String input = countryController.text.trim();

    if (input.isEmpty) {
      setState(() {
        error = "Please enter a country name";
        result = null;
      });
      return;
    }

    // Capitalize first letter
    String formatted =
        input[0].toUpperCase() + input.substring(1).toLowerCase();

    if (emergencyNumbers.containsKey(formatted)) {
      setState(() {
        result = emergencyNumbers[formatted];
        error = "";
      });
    } else {
      setState(() {
        error = "Country not found";
        result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Bot"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Find Emergency Numbers",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(
                hintText: "Enter country name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: searchCountry,
                child: const Text("Search"),
              ),
            ),
            const SizedBox(height: 25),
            if (error.isNotEmpty)
              Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            if (result != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: result!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "${entry.key}: ${entry.value}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
