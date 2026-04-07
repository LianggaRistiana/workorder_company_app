import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_companies_list/public_companies_list_bloc.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_companies_list/public_companies_list_event.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_companies_list/public_companies_list_state.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/company_item_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

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
            final items = state.companies;

            return ListPageScaffold(
                title: "Daftar Perusahaan",
                isLoading: isLoading,
                header: HorizontalButton(
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.md),
                  title: "Perusahaan Langganan",
                  description: "Perusahaan dimana saya berlangganan",
                  leadingIcon: AppIcon.membership,
                  onTap: () {},
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
