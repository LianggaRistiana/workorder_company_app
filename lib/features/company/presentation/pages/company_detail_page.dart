import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/fetch_company/company_bloc.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

class CompanyDetailPage extends StatefulWidget {
  final String companyId;
  const CompanyDetailPage({super.key, required this.companyId});

  @override
  State<CompanyDetailPage> createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<CompanyBloc>()
        .add(GetCompanyWithServiceRequested(widget.companyId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Company Details"),
      ),
      body: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          switch (state.status) {
            case CompanyStateStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case CompanyStateStatus.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          size: 48, color: Colors.redAccent),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage ?? "Something went wrong",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.red[700]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<CompanyBloc>()
                              .add(GetCompanyWithServiceRequested(widget.companyId));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              );

            case CompanyStateStatus.loaded:
              final companyData = state.selectedCompany;
              final servicesData = state.selectedCompanyServices;

              if (companyData == null ) return EmptyStateWidget(text: "Perusahaan tidak ditemukan");
              return _buildCompanyContent(context, companyData, servicesData?? []);

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildCompanyContent(
      BuildContext context, CompanyEntity companyDetail, List<ServiceEntity> serviceData) {
    final theme = Theme.of(context);
    final company = companyDetail;
    final services = serviceData;
    // final services = data.services;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company name
          Text(
            company.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Address
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  company.address,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            company.description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // Services section
          Text(
            "Services",
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          if (services.isEmpty)
            const Text("No services available.")
          else
            ...services.map((s) => _ServiceCard(service: s)),
        ],
      ),
    );
  }
}
class _ServiceCard extends StatelessWidget {
  final ServiceEntity service;

  const _ServiceCard({
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push(AppRoutes.clientFillServiceForms(service.id)),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                service.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Chip(
                  label: Text(
                    service.isActive ? "Active" : "Inactive",
                    style: TextStyle(
                      color: service.isActive
                          ? Colors.green[800]
                          : Colors.red[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor:
                      service.isActive ? Colors.green[100] : Colors.red[100],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

