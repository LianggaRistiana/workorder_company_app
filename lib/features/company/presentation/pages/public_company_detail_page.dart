import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_detail/public_company_detail_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_detail/public_company_detail_state.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_services.dart/public_company_services_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/public_services_list.dart';
import 'package:workorder_company_app/features/memberships/presentation/widgets/subcription_chip.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_action/account_action_cubit.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_action/account_action_state.dart';
import 'package:workorder_company_app/features/system_integration/presentation/widgets/paired_account_view.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/header_of_page.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

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
        BlocProvider(
          create: (_) => sl<AccountActionCubit>(),
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
          if (state.meta?.isIntegrationActive == true) {
            context
                .read<AccountActionCubit>()
                .getAccountPairingStatus(companyId);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: _buildBody(context, state),
          floatingActionButtonAnimator:
              FloatingActionButtonAnimator.noAnimation,
          floatingActionButton:
              (state.company == null || state.company!.isFaqActive == false)
                  ? null
                  : FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        context.push(AppRoutes.chatBot, extra: state.company);
                      },
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
        final meta = state.meta;
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
                // if (company.address.isNotEmpty ||
                //     company.description.isNotEmpty)
                CustomCard(
                    child: PropertyDisplay(properties: [
                  if (company.address.isNotEmpty)
                    PropertyItem.text(
                      label: "Alamat",
                      icon: Icons.location_on_outlined,
                      value: company.address.isEmpty ? "-" : company.address,
                    ),
                  if (company.description.isNotEmpty)
                    PropertyItem.text(
                      label: "Deskripsi",
                      icon: AppIcon.desc,
                      value: company.description.isEmpty
                          ? "-"
                          : company.description,
                    ),
                  if (meta != null)
                    PropertyItem.widget(
                        icon: AppIcon.membership,
                        label: "Status Keanggotaan",
                        child: SubscriptionChip(isMember: meta.isSubcribbed)),
                  if (meta != null && meta.isIntegrationActive)
                    PropertyItem.widget(
                        label: "Koneksi Akun",
                        child: _buildAccountPairingButton(companyId)),
                ])),
                PropertyTitle(label: "Daftar Layanan", icon: AppIcon.service),
                const SizedBox(height: 8),
                PublicServicesList(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildAccountPairingButton(String companyId) {
    // TODO : Add listener to detach state
    return BlocBuilder<AccountActionCubit, AccountActionState>(
        builder: (context, state) {
      if (state.status == AccountActionStateStatus.loading ||
          state.status == AccountActionStateStatus.detachLoading) {
        return SmartShimmer(
          key: const ValueKey('loading'),
          placeholders: [
            ShimmerPlaceholder(
                height: 60, width: double.infinity, borderRadius: 50),
          ],
        );
      }
      return PairedAccountView(
        companyId: companyId,
        isPaired: state.externalAccount != null,
        onConnect: () async {
          final result = await context.push<ExternalUserEntity?>(
              AppRoutes.pairAccount.fillId(companyId));

          if (!context.mounted) return;
          if (result != null) {
            context.read<AccountActionCubit>().replaceExternalAccount(result);
            // FIXME : REFETCH WHEN DETACH ACCOUNT OR REPLACE ACCOUNT
          }
        },
        onDetach: () {
          final account = state.externalAccount;
          if (account == null) return;

          context.read<AccountActionCubit>().detachAccount(account.id);
        },
        externalUser: state.externalAccount,
      );
    });
  }
}
