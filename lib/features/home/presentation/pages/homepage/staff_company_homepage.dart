import 'package:flutter/material.dart';

class StaffCompanyHomepage extends StatelessWidget {
  const StaffCompanyHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StaffCompanyHomepage'),
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
