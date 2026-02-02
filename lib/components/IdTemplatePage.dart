import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../components/gradient_button.dart';

class IdTemplatePage extends StatefulWidget {
  const IdTemplatePage({super.key});

  @override
  State<IdTemplatePage> createState() => _IdTemplatePageState();
}

class _IdTemplatePageState extends State<IdTemplatePage> {
  File? imageFile;
  bool scanning = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      scanId();
    });
  }

  /// Step 1: Capture Image
  Future<void> scanId() async {
    try {
      final picker = ImagePicker();
      final photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) {
        Navigator.pop(context, false);
        return;
      }

      // Step 2: Crop Image
      File? cropped = await cropImage(File(photo.path));
      if (cropped == null) return;

      setState(() {
        imageFile = cropped;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera error: $e")),
      );
    }
  }

  /// Crop Image
  Future<File?> cropImage(File file) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop ID',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop ID',
        ),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  /// Submit Image (with loading)
  void submit() async {
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please scan your ID")),
      );
      return;
    }

    setState(() => scanning = true);

    // Show loading for 2 seconds to simulate verification
    await Future.delayed(const Duration(seconds: 2));

    setState(() => scanning = false);

    // Success → go back to RegisterPage
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan ID")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            Expanded(
              child: Center(
                child: scanning
                    ? const CircularProgressIndicator()
                    : imageFile == null
                    ? const Text("Opening Camera...")
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Rescan Button
            if (imageFile != null && !scanning)
              GradientButton(
                text: "RESCAN",
                onPressed: scanId,
              ),

            const SizedBox(height: 10),

            // Verify Button
            if (imageFile != null && !scanning)
              GradientButton(
                text: "VERIFY ID",
                onPressed: submit,
              ),
          ],
        ),
      ),
    );
  }
}
