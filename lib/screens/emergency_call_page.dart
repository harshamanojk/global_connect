import 'package:flutter/material.dart';

class EmergencyCallPage extends StatelessWidget {
  const EmergencyCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Calling"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Status: Ready to Call (Offline Mode)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Emergency Contacts Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Emergency Contacts",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Contact List
            Expanded(
              child: ListView(
                children: [

                  emergencyTile(
                    icon: Icons.local_hospital,
                    name: "Ambulance",
                    number: "102",
                  ),

                  emergencyTile(
                    icon: Icons.local_police,
                    name: "Police",
                    number: "100",
                  ),

                  emergencyTile(
                    icon: Icons.fire_truck,
                    name: "Fire",
                    number: "101",
                  ),

                  emergencyTile(
                    icon: Icons.person,
                    name: "Emergency Contact",
                    number: "+91 9876543210",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Recent Calls (Placeholder)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Calls",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "No calls yet",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Contact Card Widget
  Widget emergencyTile({
    required IconData icon,
    required String name,
    required String number,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.red, size: 30),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(number),

        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          onPressed: () {
            // Real calling will be added later
          },
        ),
      ),
    );
  }
}
