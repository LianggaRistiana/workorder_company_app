import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/services/domain/entities/form_order_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/modern_app_bar.dart';

class ServiceDetailPage extends StatefulWidget {
  final String serviceId;

  const ServiceDetailPage({super.key, required this.serviceId});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  late final ServicesBloc _servicesBloc;

  @override
  void initState() {
    super.initState();
    _servicesBloc = sl<ServicesBloc>()
      ..add(GetServiceByIdRequested(widget.serviceId));
  }

  @override
  void dispose() {
    _servicesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      bloc: _servicesBloc,
      builder: (context, state) {
        if (state is ServicesLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ServicesError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Service Detail')),
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is ServicesLoaded) {
          if (state.isSubLoading == true) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final service = state.selectedService;
          if (service == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Service Detail')),
              body: Center(
                child: Text(
                  state.errorMessage ?? 'Service not found',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // ✅ Perbaikan utama: DefaultTabController melingkupi seluruh Scaffold
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text(service.title),
                bottom: const TabBar(
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: "Overview"),
                    Tab(text: "Work Order Forms"),
                    Tab(text: "Report Forms"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _buildOverviewTab(service),
                  _buildFormsTab(service.workOrderForms, "Work Order Forms"),
                  _buildFormsTab(service.reportForms, "Report Forms"),
                ],
              ),
            ),
          );
          // return DefaultTabController(
          //   length: 3,
          //   child: Scaffold(
          //     body: NestedScrollView(
          //       headerSliverBuilder: (context, innerBoxIsScrolled) {
          //         return [
          //           ModernAppBar(
          //             title: service.title,
          //             tabBar: const TabBar(
          //               labelColor: Colors.black,
          //               indicatorColor: Colors.blue,
          //               dividerColor: Colors.transparent,
          //               tabs: [
          //                 Tab(text: "Overview"),
          //                 Tab(text: "WorkOrder Forms"),
          //                 Tab(text: "Report Forms"),
          //               ],
          //             ),
          //           ),
          //         ];
          //       },
          //       body: TabBarView(
          //         children: [
          //           _buildOverviewTab(service),
          //           _buildFormsTab(service.workOrderForms, "Work Order Forms"),
          //           _buildFormsTab(service.reportForms, "Report Forms"),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        }

        return const Scaffold(
          body: SizedBox(),
        );
      },
    );
  }

  Widget _buildOverviewTab(ServiceEntity service) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟦 Card utama: Informasi umum
          Row(
            children: [
              _buildAccessTypeChip(service.accessType),
              const SizedBox(width: 8),
              Chip(
                label: Text(service.isActive ? "Active" : "Inactive"),
                backgroundColor: service.isActive
                    ? Colors.green.shade50
                    : Colors.grey.shade200,
                avatar: Icon(
                  service.isActive ? Icons.check_circle : Icons.cancel,
                  color: service.isActive ? Colors.green : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          _buildSectionTitle("Description"),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  // Text(
                  //   service.title,
                  //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  // ),

                  // Description
                  Text(
                    service.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🟩 Section: Required Staff
          _buildSectionTitle("Required Staff"),

          if (service.requiredStaff.isEmpty)
            const Text("No required staff specified.")
          else
            Column(
              children: service.requiredStaff.map((staff) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child:
                          Icon(Icons.person_outline, color: Colors.blueAccent),
                    ),
                    title: Text(
                      staff.position.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Min: ${staff.minimumStaff}, Max: ${staff.maximumStaff}',
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFormsTab(List<FormOrderEntity>? formOrders, String title) {
    if (formOrders == null || formOrders.isEmpty) {
      return Center(child: Text("No $title available."));
    }

    final sortedForms = [...formOrders]
      ..sort((a, b) => a.order.compareTo(b.order));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedForms.length,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) => _buildFormCard(
        sortedForms[index].form,
        onTap: () => context.push(
          AppRoutes.ownerFormDetail(sortedForms[index].form.id),
        ),
      ),
    );
  }

  Widget _buildFormCard(dynamic form, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      highlightColor: Colors.transparent,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Access Type
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      form.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildAccessTypeChip(form.accessType),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                form.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
              ),

              const SizedBox(height: 16),
              const Divider(),

              // Accessible by
              if (form.accessibleBy.isNotEmpty) ...[
                Text(
                  "Accessible By",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: form.accessibleBy
                      .map<Widget>(
                        (role) => Chip(
                          label: Text(role),
                          backgroundColor: Colors.orange.shade50,
                          side: BorderSide(color: Colors.orange.shade100),
                        ),
                      )
                      .toList(),
                ),
              ],

              const SizedBox(height: 16),

              // Allowed positions
              if (form.allowedPositions.isNotEmpty) ...[
                Text(
                  "Allowed Positions",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: form.allowedPositions
                      .map<Widget>(
                        (pos) => Chip(
                          label: Text(pos.name),
                          backgroundColor: Colors.green.shade50,
                          side: BorderSide(color: Colors.green.shade100),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccessTypeChip(String accessType) {
    IconData icon;
    Color bgColor;

    switch (accessType.toLowerCase()) {
      case "public":
        icon = Icons.public;
        bgColor = Colors.blue.shade50;
        break;
      case "member-only":
        icon = Icons.group;
        bgColor = Colors.orange.shade50;
        break;
      case "internal":
        icon = Icons.business;
        bgColor = Colors.purple.shade50;
        break;
      default:
        icon = Icons.lock;
        bgColor = Colors.grey.shade200;
    }

    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(accessType),
      backgroundColor: bgColor,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
