import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_detail/public_company_detail_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_detail/public_company_detail_state.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_services.dart/public_company_services_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/public_services.dart';
import 'package:workorder_company_app/features/memberships/presentation/widgets/subcription_chip.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/header_of_page.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class PublicCompanyDetailPage extends StatelessWidget {
  final String companyId;

  const PublicCompanyDetailPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<PublicCompanyDetailCubit>()..getCompanyDetail(companyId),
        ),
        BlocProvider(
          create: (_) => sl<PublicCompanyServicesCubit>(),
        ),
      ],
      child: _View(companyId),
    );
  }
}

class _View extends StatelessWidget {
  final String companyId;

  const _View(this.companyId);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PublicCompanyDetailCubit, PublicCompanyDetailState>(
      listener: (context, state) {
        if (state.status == PublicCompaniesListStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
        if (state.status == PublicCompaniesListStatus.loaded &&
            state.company != null) {
          context.read<PublicCompanyServicesCubit>().getServices(companyId);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: _buildBody(context, state),
          floatingActionButton: state.company == null
              ? null
              : FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(AppIcon.qna),
                ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PublicCompanyDetailState state) {
    switch (state.status) {
      case PublicCompaniesListStatus.initial:
        return const SizedBox.shrink();
      case PublicCompaniesListStatus.loading:
        return const Center(child: AppLoading());

      case PublicCompaniesListStatus.error:
        return ErrorBody(
            errorMessage: state.errorMessage ?? "Terjadi kesalahan",
            onRetry: () {
              context
                  .read<PublicCompanyDetailCubit>()
                  .getCompanyDetail(companyId);
            });
      case PublicCompaniesListStatus.loaded:
        final company = state.company;
        if (company == null) {
          return ErrorBody(errorMessage: "Perusahaan tidak ditemukan");
        }
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<PublicCompanyDetailCubit>()
                .getCompanyDetail(companyId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderOfPage(title: company.name, icon: AppIcon.company),
                const SizedBox(height: 8),
                if (company.address.isNotEmpty ||
                    company.description.isNotEmpty)
                  CustomCard(
                      child: PropertyDisplay(properties: [
                    PropertyItem.text(
                      label: "Alamat",
                      icon: Icons.location_on_outlined,
                      value: company.address.isEmpty ? "-" : company.address,
                    ),
                    PropertyItem.text(
                      label: "Deskripsi",
                      icon: AppIcon.desc,
                      value: company.description.isEmpty
                          ? "-"
                          : company.description,
                    ),

                    // FIXME[API REQUIRED] : fix this later
                    PropertyItem.widget(
                        icon: AppIcon.membership,
                        label: "Status Keanggotaan",
                        child: SubscriptionChip(isMember: true))
                  ])),
                PropertyTitle(label: "Daftar Layanan", icon: AppIcon.service),
                const SizedBox(height: 8),
                PublicServicesList()
              ],
            ),
          ),
        );
    }
  }
}
