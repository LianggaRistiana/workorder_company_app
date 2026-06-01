import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_companies_list/public_companies_list_bloc.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_companies_list/public_companies_list_event.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_companies_list/public_companies_list_state.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/company_item_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';
import 'package:workorder_company_app/shared/widgets/search_bar.dart';

class PublicCompaniesListPage extends StatelessWidget {
  const PublicCompaniesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            sl<PublicCompaniesListBloc>()..add(GetPublicCompaniesRequested()),
        child: BlocConsumer<PublicCompaniesListBloc, PublicCompaniesListState>(
          listener: (context, state) {
            if (state.status == PublicCompaniesListStatus.error) {
              context.showError(state.errorMessage ?? "Terjadi kesalahan");
            }
          },
          builder: (context, state) {
            final isLoading = state.status == PublicCompaniesListStatus.loading;
            final items = state.filteredCompanies;

            return ListPageScaffold(
                title: "Daftar Perusahaan",
                isLoading: isLoading,
                loadingMessage: "Memuat Daftar Perusahaan...",
                header: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 4, bottom: 4),
                  child: AppSearchBar(
                    featureName: "Perusahaan",
                    onChanged: (value) {
                      context.read<PublicCompaniesListBloc>().add(
                            SetCompaniesFilter(
                              filter: state.filter.copyWith(search: value),
                            ),
                          );
                    },
                    initialValue: state.filter.search,
                  ),
                ),
                items: items,
                onRefresh: () async {
                  context
                      .read<PublicCompaniesListBloc>()
                      .add(GetPublicCompaniesRequested());
                },
                itemBuilder: (company) => CompanyItemCard(
                      company: company,
                      onTap: () {
                        context.push(
                            AppRoutes.publicCompaniesDetail.fillId(company.id));
                      },
                    ));
          },
        ));
  }
}
