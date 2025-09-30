import 'package:flutter/material.dart';

class ManagerCompanyHomePage extends StatelessWidget {
  const ManagerCompanyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ManagerCompanyHomePage'),
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
