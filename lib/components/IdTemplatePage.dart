// ignore_for_file: use_build_context_synchronously

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
  bool loadingCamera = false;

  @override
  void initState() {
    super.initState();
    // Automatically open camera after a short delay
    Future.delayed(const Duration(milliseconds: 300), scanId);
  }

  // ================= OPEN CAMERA =================
  Future<void> scanId() async {
    if (loadingCamera) return;

    try {
      setState(() => loadingCamera = true);

      final picker = ImagePicker();
      final photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      // User canceled camera
      if (photo == null) {
        Navigator.pop(context, false);
        return;
      }

      final cropped = await cropImage(File(photo.path));

      // User canceled crop
      if (cropped == null) {
        Navigator.pop(context, false);
        return;
      }

      setState(() => imageFile = cropped);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to open camera")),
      );
      Navigator.pop(context, false);
    } finally {
      setState(() => loadingCamera = false);
    }
  }

  // ================= CROP IMAGE =================
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
        IOSUiSettings(title: 'Crop ID'),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  // ================= VERIFY =================
  Future<void> verify() async {
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please scan your ID")),
      );
      return;
    }

    setState(() => scanning = true);

    // Simulate verification delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() => scanning = false);

    // SUCCESS → return true to RegisterPage
    Navigator.pop(context, true);
  }

  // ================= PREVENT BACK EXIT =================
  Future<bool> onWillPop() async {
    Navigator.pop(context, false); // Return false if back pressed
    return false;
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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

              // RESCAN BUTTON
              if (imageFile != null && !scanning)
                GradientButton(
                  text: "RESCAN",
                  onPressed: scanId,
                ),

              const SizedBox(height: 10),

              // VERIFY BUTTON
              if (imageFile != null && !scanning)
                GradientButton(
                  text: "VERIFY ID",
                  onPressed: verify,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
