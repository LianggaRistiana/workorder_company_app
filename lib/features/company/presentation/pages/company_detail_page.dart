import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/fetch_company/company_bloc.dart';
import 'package:workorder_company_app/features/services_legacy/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services_legacy/presentation/widgets/service_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

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
                          context.read<CompanyBloc>().add(
                              GetCompanyWithServiceRequested(widget.companyId));
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

              if (companyData == null)
                return EmptyStateWidget(text: "Perusahaan tidak ditemukan");
              return _buildCompanyContent(
                  context, companyData, servicesData ?? []);

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildCompanyContent(BuildContext context, CompanyEntity companyDetail,
      List<ServiceEntity> serviceData) {
    final theme = Theme.of(context);
    final company = companyDetail;
    final services = serviceData;
    // final services = data.services;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.home_work_outlined,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),

              // Nama & Alamat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Perusahaan
                    Text(
                      company.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // optional, agar tidak terlalu tinggi
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Alamat Perusahaan
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            company.address,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                            maxLines: 3, // optional
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Description
          Text(
            company.description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // Services section
          SectionTitle("Layanan Perusahaan"),
          const SizedBox(height: 8),
          CustomList(
              items: services,
              emptyFooterHeight: 20,
              separatorHeight: AppSpacing.sm,
              scrollable: false,
              isReorderable: false,
              itemBuilder: (service, _) => ServiceItem(
                  service: service,
                  onTap: () {
                    context.push(AppRoutes.publicServiceDetail.fillId(service.id));
                  })),
        ],
      ),
    );
  }
}
