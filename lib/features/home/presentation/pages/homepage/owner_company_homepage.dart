import 'package:flutter/material.dart';

class OwnerCompanyHomepage extends StatelessWidget {
  const OwnerCompanyHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OwnerCompanyHomepage'),
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
