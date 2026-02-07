import 'dart:async';
import 'package:flutter/material.dart';

class CallingPage extends StatefulWidget {
  final String callerName;
  final String receiverName;

  const CallingPage({
    super.key,
    required this.callerName,
    required this.receiverName,
  });

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  bool callPicked = false;
  int seconds = 0;
  Timer? timer;

  void startCallTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        seconds++;
      });

      // Auto hang-up after 20 seconds
      if (seconds >= 20) {
        timer?.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Call ended automatically (20 seconds)")),
        );
        Navigator.pop(context);
      }
    });
  }

  void pickUpCall() {
    setState(() {
      callPicked = true;
    });
    startCallTimer();
  }

  void endCall() {
    timer?.cancel();
    Navigator.pop(context);
  }

  String formatTime(int sec) {
    int min = sec ~/ 60;
    int remainingSec = sec % 60;
    return "$min:${remainingSec.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.callerName} → ${widget.receiverName}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              callPicked ? Icons.call : Icons.call_end,
              color: callPicked ? Colors.green : Colors.red,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              callPicked
                  ? "Call in progress: ${formatTime(seconds)}"
                  : "Ringing ${widget.receiverName}...",
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (!callPicked)
              ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text("Pick Up (simulate)"),
                onPressed: pickUpCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
              ),
            if (callPicked)
              ElevatedButton.icon(
                icon: const Icon(Icons.call_end),
                label: const Text("Hang Up"),
                onPressed: endCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
