import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';

class ManagerCompanyHomepage extends StatelessWidget {
  const ManagerCompanyHomepage({super.key});

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
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
              children: [
                MenuItem(
                    icon: Icons.inbox_outlined,
                    label: "Pengajuan Layanan",
                    onTap: () {
                      context.go(AppRoutes.managerCsr);
                    }),
                MenuItem(
                    icon: Icons.assignment_outlined,
                    label: "Workorder",
                    onTap: () {
                      context.go(AppRoutes.managerWorkorder);
                    }),
                MenuItem(icon: Icons.people_alt_outlined, label: "Pegawai", onTap: () {}),
                MenuItem(icon: Icons.badge_outlined, label: "Posisi Pegawai", onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
