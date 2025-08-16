import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Last updated: August 15, 2025\n\n'
          'Please read these terms and conditions carefully before using Our Service.\n\n'
          'Interpretation and Definitions...\n\n'
          'Acknowledgement...\n\n'
          'Links to Other Websites...\n\n'
          'Termination...\n\n'
          'Limitation of Liability...\n\n'
          '"AS IS" and "AS AVAILABLE" Disclaimer...\n\n'
          'Governing Law...\n\n'
          'Disputes Resolution...\n\n'
          'Contact Us\n'
          'If you have any questions about these Terms and Conditions, You can contact us...\n\n'
          '--- [This is placeholder text. Replace with your full Terms of Service.] ---',
        ),
      ),
    );
  }
}
