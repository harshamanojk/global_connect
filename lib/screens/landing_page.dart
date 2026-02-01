import 'package:flutter/material.dart';
import 'package:global_connect/components/gradient_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 700;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: isWide
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildImageSection()),
                  const SizedBox(width: 40),
                  Expanded(child: _buildContent(context, isWide)),
                ],
              )
                  : _buildContent(context, isWide),
            ),
          );
        },
      ),
    );
  }

  // Logo Section
  Widget _buildImageSection() {
    return Center(
      child: Image.asset(
        'assets/images/LOGO.jpg',
        height: 260,
        fit: BoxFit.contain,
      ),
    );
  }

  // Main Content
  Widget _buildContent(BuildContext context, bool isWide) {
    final double fontSizeTitle = isWide ? 36 : 30;
    final double fontSizeSubtitle = 16;
    final double buttonWidth = isWide ? 300 : double.infinity;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isWide)
            Image.asset(
              'assets/images/LOGO.jpg',
              height: 200,
              fit: BoxFit.contain,
            ),
          const SizedBox(height: 30),
          Text(
            'Welcome To GlobalConnect',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSizeTitle,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Stay Connected Anywhere',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSizeTitle - 6,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),

          // LOGIN Button
          SizedBox(
            width: buttonWidth,
            child: GradientButton(
              text: 'LOGIN',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Coming Soon')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // REGISTER Button
          SizedBox(
            width: buttonWidth,
            child: GradientButton(
              text: 'REGISTER',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Register Coming Soon')),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
