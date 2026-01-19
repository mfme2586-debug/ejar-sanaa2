import 'package:flutter/material.dart';
import 'package:ejar_sanaa/core/theme/app_theme.dart';

class AddListingScreen extends StatelessWidget {
  const AddListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة إعلان جديد')),
      body: const Center(
        child: Text('Add Listing Screen - TODO: Implement wizard form'),
      ),
    );
  }
}
