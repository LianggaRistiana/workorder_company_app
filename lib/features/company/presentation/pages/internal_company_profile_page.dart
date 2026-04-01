import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class InternalCompanyProfilePage extends StatefulWidget {
  const InternalCompanyProfilePage({super.key});

  @override
  State<InternalCompanyProfilePage> createState() =>
      _InternalCompanyProfilePageState();
}

class _InternalCompanyProfilePageState
    extends State<InternalCompanyProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<InternalCompanyCubit>().loadCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Perusahaan"),
      ),
      body: BlocBuilder<InternalCompanyCubit, InternalCompanyState>(
        builder: (context, state) {
          if (state.company == null && state.isLoading) {
            return const Center(child: AppLoading());
          }

          if (state.company == null) {
            return const Center(
              child: Text("Data perusahaan tidak tersedia"),
            );
          }

          final company = state.company!;

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<InternalCompanyCubit>().loadCompany();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                if (state.warnings.isNotEmpty) ...[
                  _WarningBlock(warnings: state.warnings),
                  const SizedBox(height: 24),
                ],
                _CompanyHeader(company: company),
                // const SizedBox(height: 24)
                CustomCard(
                    child: PropertyDisplay(properties: [
                  PropertyItem.text(
                      label: "Nama Perusahaan",
                      icon: AppIcon.company,
                      value: company.name),
                  PropertyItem.text(
                    label: "Alamat",
                    icon: Icons.location_on_outlined,
                    value: company.address.isEmpty
                        ? "Alamat belum diisi"
                        : company.address,
                  ),
                  PropertyItem.text(
                    label: "Deskripsi",
                    icon: AppIcon.desc,
                    value: company.description.isEmpty
                        ? "Deskripsi belum diisi"
                        : company.description,
                  ),
                ])),
                TextButton.icon(
                  onPressed: () {
                    debugPrint("Edit Profil Perusahaan");
                    context.push(AppRoutes.companyUpdate, extra: company);
                  },
                  label: Text("Edit Profil Perusahaan"),
                  icon: Icon(AppIcon.edit),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CompanyHeader extends StatelessWidget {
  final CompanyEntity company;

  const _CompanyHeader({required this.company});

  @override
  Widget build(BuildContext context) {
    final color = company.isActive ? Colors.green : Colors.red;

    return CustomCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            child: Text(
              company.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: color),
                    const SizedBox(width: 6),
                    Text(
                      company.isActive
                          ? "Perusahaan Aktif"
                          : "Perusahaan Tidak Aktif",
                      style: TextStyle(color: color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBlock extends StatelessWidget {
  final List<String> warnings;

  const _WarningBlock({required this.warnings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withAlpha(120),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: warnings
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(e)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
