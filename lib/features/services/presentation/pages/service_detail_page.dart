import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_form_entity.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_form_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

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
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    expandedHeight: 160,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      expandedTitleScale: 1.5,
                      titlePadding: EdgeInsets.only(bottom: 64),
                      title: Text(service.title),
                    ),
                    bottom: const TabBar(
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: "Overview"),
                        Tab(text: "Work Forms"),
                        Tab(text: "Report Forms"),
                      ],
                    ),
                  ),
                ],
                body: TabBarView(
                  children: [
                    _buildOverviewTab(service),
                    _buildFormsTab(service.workOrderForms, "WorkOrder Forms"),
                    _buildFormsTab(service.reportForms, "Report Forms"),
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: SizedBox(),
        );
      },
    );
  }

  Widget _buildFormsTab(List<ServiceFormEntity>? serviceForms, String title) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CustomList(
        items: serviceForms ?? [],
        separatorHeight: 8,
        emptyWidget: EmptyStateWidget(
          text: "Tidak ada $title",
        ),
        itemBuilder: (serviceForm, _) => ServiceFormCard(
          serviceForm: serviceForm,
        ),
      ),
    );
  }

  Widget _buildOverviewTab(ServiceEntity service) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
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
            child: Text(
              service.description,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 24),
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
                    child: Icon(Icons.person_outline, color: Colors.blueAccent),
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
