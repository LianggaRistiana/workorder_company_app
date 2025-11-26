import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/fetch_company/company_bloc.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/company_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil bloc yang sudah disediakan di parent
    final bloc = context.read<CompanyBloc>();

    // Trigger load data pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetCompaniesRequested());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Perusahaan"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
            ),
            child: CustomInputField(
              label: "Cari Perusahaan",
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          switch (state.status) {
            case CompanyStateStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case CompanyStateStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? "Terjadi kesalahan",
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        bloc.add(GetCompaniesRequested());
                      },
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );

            case CompanyStateStatus.loaded:
              if (state.companies.isEmpty) {
                return const Center(
                  child: Text("Belum ada perusahaan"),
                );
              }

              return RefreshIndicator(
                  onRefresh: () async {
                    bloc.add(GetCompaniesRequested());
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HorizontalButton(
                          margin: const EdgeInsets.all(AppSpacing.md),
                          title: "Perusahaan Langganan",
                          description:
                              "Perusahaan dimana saya berlangganan",
                          leadingIcon: Icons.home_work_outlined,
                          onTap: () {},
                        ),
                        CustomList(
                            scrollable: false,
                            items: state.companies,
                            itemBuilder: (company, _) => CompanyCard(
                                  company: company,
                                  onTap: () => context.push(
                                      AppRoutes.clientCompanyDetail(
                                          company.id)),
                                ))
                      ],
                    ),
                  ));

            case CompanyStateStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
