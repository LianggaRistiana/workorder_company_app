import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dummy data
    final companyName = "PT Maju Jaya";
    final companyAddress = "Jl. Contoh No.123, Bali";

    // Menu items
    final menuItems = [
      {
        'icon': Icons.badge_rounded,
        'label': 'Positions',
        'route': AppRoutes.ownerPositions
      },
      {
        'icon': Icons.home_repair_service_rounded,
        'label': 'Services',
        'route': AppRoutes.ownerServices
      },
      {
        'icon': Icons.article_rounded,
        'label': 'Forms',
        'route': AppRoutes.ownerForms
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Company"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            tooltip: "Edit Company",
            onPressed: () {
              // TODO: Navigate to company edit page
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Company Card ---
            CustomCard(
              child: Row(
                children: [
                  // Company Logo / Avatar
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: const Icon(
                      Icons.apartment_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Company Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          companyName,
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          companyAddress,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: const Text('Active',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// --- Section Title ---
            Text(
              "Company Management",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            /// --- Menu Grid ---
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return _DashboardCard(
                  icon: item['icon'] as IconData,
                  label: item['label'] as String,
                  onTap: () => context.go(item['route'] as String),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// --- Widget Kartu Menu Individual ---
class _DashboardCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: widget.onTap,
      onHover: (hovering) => setState(() => _isHovered = hovering),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _isHovered
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surfaceVariant.withOpacity(0.6),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 40, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              widget.label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
