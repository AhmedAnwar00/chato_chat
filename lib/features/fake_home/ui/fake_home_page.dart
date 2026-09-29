import 'package:flutter/material.dart';

/// Temporary test-only page. Remove after sign-in navigation is verified.
class FakeHomePage extends StatelessWidget {
  const FakeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Login Successful'),
      ),
    );
  }
}
