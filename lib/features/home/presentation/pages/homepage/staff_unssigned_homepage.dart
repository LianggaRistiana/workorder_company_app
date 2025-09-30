import 'package:flutter/material.dart';

class StaffUnssignedHomepage extends StatelessWidget {
  const StaffUnssignedHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StaffUnssignedHomepage'),
      ),
      body: const Center(
        child: Text(
          'Hi',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
