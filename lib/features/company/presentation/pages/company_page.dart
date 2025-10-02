import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // jangan lupa import GoRouter

class CompanyPage extends StatelessWidget {
  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final companyName = "PT Maju Jaya";
    final companyAddress = "Jl. Contoh No.123, Bali";
    final isActive = true; // status aktif / tidak

    // Menu items
    final menuItems = [
      {'icon': Icons.badge, 'label': 'Position', 'route': '/owner/positions'},
      {'icon': Icons.build, 'label': 'Service', 'route': '/owner/services'},
      {'icon': Icons.format_list_bulleted, 'label': 'Form', 'route': '/owner/forms'},
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Company Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      companyAddress,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Status
                    Chip(
                      label: Text(
                        isActive ? 'Active' : 'Inactive',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: isActive ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Menu Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: menuItems.map((item) {
                  return InkWell(
                    onTap: () {
                      final route = item['route'] as String?;
                      if (route != null) {
                        context.go(route); // arahkan ke route sesuai item
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            size: 36,
                            color: Colors.blue.shade800,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
