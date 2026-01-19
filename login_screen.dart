import 'package:flutter/material.dart';
import 'package:ejar_sanaa/core/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: const Center(
        child: Text('Login Screen - TODO'),
      ),
    );
  }
}
