import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums/system_integration_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_detail/public_company_detail_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_detail/public_company_detail_state.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_services.dart/public_company_services_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/public_services_list.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/claim/claim_membership_code_cubit.dart';
import 'package:workorder_company_app/features/memberships/presentation/widgets/claim_token_widget.dart';
import 'package:workorder_company_app/features/memberships/presentation/widgets/subcription_chip.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_action/account_action_cubit.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_action/account_action_state.dart';
import 'package:workorder_company_app/features/system_integration/presentation/widgets/paired_account_item.dart';
import 'package:workorder_company_app/features/system_integration/presentation/widgets/pairing_account_button.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
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
          create: (_) => sl<ClaimMembershipCodeCubit>(),
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
        final integrationType = meta?.integrationType;

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
                  if (meta != null &&
                      meta.isIntegrationActive &&
                      integrationType != null) ...[
                    PropertyItem.widget(
                        label: "Koneksi Akun",
                        child:
                            _buildAccountExternalInformation(integrationType)),
                  ]
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

  Widget _buildAccountExternalInformation(IntegrationType integrationType) {
    return BlocConsumer<AccountActionCubit, AccountActionState>(
      listener: (context, state) {
        if (state.status == AccountActionStateStatus.detachError) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
        if (AccountActionStateStatus.detachSuccess == state.status) {
          context.read<PublicCompanyDetailCubit>().getCompanyDetail(companyId);
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading || state.isDetachLoading;
        final externalAccount = state.externalAccount;

        if (isLoading) {
          return SmartShimmer(
            key: const ValueKey('loading'),
            placeholders: [
              ShimmerPlaceholder(
                  height: 60, width: double.infinity, borderRadius: 50),
            ],
          );
        }

        if (state.externalAccount == null) {
          return switch (integrationType) {
            IntegrationType.claimCode =>
              _buildTokenMemberClaim(context, companyId),
            IntegrationType.externalSystem =>
              _buildAccountPairingButton(context, companyId),
          };
        }

        if (externalAccount != null) {
          return PairedAccountItem(
            externalUser: externalAccount,
            isLoading: isLoading,
            onDetach: () {
              final account = state.externalAccount;
              if (account == null) return;
              context.read<AccountActionCubit>().detachAccount(account.id);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTokenMemberClaim(BuildContext context, String companyId) {
    return ClaimTokenWidget(
      companyId: companyId,
      onClaimSuccess: () {
        context.read<PublicCompanyDetailCubit>().getCompanyDetail(companyId);
      },
    );
  }

  Widget _buildAccountPairingButton(BuildContext context, String companyId) {
    return PairingAccountButton(
        companyId: companyId,
        onConnect: () {
          context.read<PublicCompanyDetailCubit>().getCompanyDetail(companyId);
        });
  }
}
