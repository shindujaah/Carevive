import 'package:flutter/material.dart';

class FrontScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Path to your logo
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
