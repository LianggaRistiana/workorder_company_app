import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/fetch_company/company_bloc.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/company_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';

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
        title: const Text("Companies"),
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
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CustomList(
                          scrollable: true,
                          items: state.companies,
                          itemBuilder: (company, _) => CompanyCard(
                                company: company,
                                onTap: () => context.push(
                                    AppRoutes.clientCompanyDetail(company.id)),
                              ))));

            case CompanyStateStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
