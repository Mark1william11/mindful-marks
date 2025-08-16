import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Last updated: August 15, 2025\n\n'
          'This Privacy Policy describes Our policies and procedures on the collection, '
          'use and disclosure of Your information when You use the Service and tells '
          'You about Your privacy rights and how the law protects You.\n\n'
          'We use Your Personal data to provide and improve the Service. By using the '
          'Service, You agree to the collection and use of information in accordance '
          'with this Privacy Policy.\n\n'
          'Interpretation and Definitions...\n\n'
          'Collecting and Using Your Personal Data...\n\n'
          'Types of Data Collected...\n\n'
          'Use of Your Personal Data...\n\n'
          'Retention of Your Personal Data...\n\n'
          'Transfer of Your Personal Data...\n\n'
          'Security of Your Personal Data...\n\n'
          'Children\'s Privacy...\n\n'
          'Links to Other Websites...\n\n'
          'Changes to this Privacy Policy...\n\n'
          'Contact Us\n'
          'If you have any questions about this Privacy Policy, You can contact us...\n\n'
          '--- [This is placeholder text. Replace with your full Privacy Policy.] ---',
        ),
      ),
    );
  }
}