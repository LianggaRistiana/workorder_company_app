import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_state.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/internal_company_card.dart';
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
    context.read<InternalGetCompanyCubit>().loadCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Perusahaan"),
      ),
      body: BlocBuilder<InternalGetCompanyCubit, InternalGetCompanyState>(
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

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<InternalGetCompanyCubit>()
                    .loadCompany(forceRefresh: true);
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  Hero(
                    tag: "company-card",
                    child:
                        InternalCompanyCard(), // FIXME[HIGH] : fix this later
                    // child: _CompanyHeader(company: company)
                  ),
                  const SizedBox(height: AppSpacing.md),
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
            ),
          );
        },
      ),
    );
  }
}
