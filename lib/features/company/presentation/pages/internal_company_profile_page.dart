import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

// TODO : add permissionGate For this Feature
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
            return const Center(child: CircularProgressIndicator());
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
              padding: const EdgeInsets.all(20),
              children: [
                if (state.warnings.isNotEmpty) ...[
                  _WarningBlock(warnings: state.warnings),
                  const SizedBox(height: 24),
                ],
                _CompanyHeader(company: company),
                // const SizedBox(height: 24)
                TextButton.icon(
                  onPressed: () {
                    debugPrint("Edit Profil Perusahaan");
                    context.push(AppRoutes.companyUpdate, extra: company);
                  },
                  label: Text("Edit Profil Perusahaan"),
                  icon: const Icon(Icons.edit),
                ),

                const SizedBox(height: 32),
                Text(
                  "Informasi Perusahaan",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _InfoTile(
                  icon: Icons.business,
                  label: "Nama Perusahaan",
                  value: company.name,
                ),
                const SizedBox(height: 16),
                _InfoTile(
                  icon: Icons.location_on_outlined,
                  label: "Alamat",
                  value: company.address.isEmpty
                      ? "Alamat belum diisi"
                      : company.address,
                ),
                const SizedBox(height: 16),
                _InfoTile(
                  icon: Icons.description_outlined,
                  label: "Deskripsi",
                  value: company.description.isEmpty
                      ? "Deskripsi belum diisi"
                      : company.description,
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
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
