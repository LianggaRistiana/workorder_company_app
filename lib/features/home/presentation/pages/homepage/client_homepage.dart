import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class ClientHomepage extends StatelessWidget {
  const ClientHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Identitas
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                title: const Text(
                  "John Doe",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: const Text("Client ID: 123456"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Menu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            // Grid Menu
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
              children: [
                _buildMenuItem(Icons.assignment, "Pengajuan Layanan Saya",
                    () => context.push(AppRoutes.clientServiceRequest)),
                _buildMenuItem(Icons.receipt_long, "Invoices", () {}),
                _buildMenuItem(Icons.chat, "Chat", () {}),
                _buildMenuItem(Icons.settings, "Settings", () {}),
                _buildMenuItem(Icons.notifications, "Notifications", () {}),
                _buildMenuItem(Icons.help_outline, "Help", () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
