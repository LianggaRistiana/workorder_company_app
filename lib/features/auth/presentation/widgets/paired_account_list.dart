import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/accounts/external_accounts_cubit.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/accounts/external_accounts_state.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class PairedAccountList extends StatelessWidget {
  const PairedAccountList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExternalAccountsCubit>()..loadAccounts(),
      child: BlocConsumer<ExternalAccountsCubit, ExternalAccountsState>(
          listener: (context, state) {
        if (state.hasAnyError) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      }, builder: (context, state) {
        final cubit = context.watch<ExternalAccountsCubit>();
        final detachTargetLoading = cubit.detachingAccountId;

        return Column(
          children: [
            PropertyTitle(label: "Akun eksternal terhubung"),
            const SizedBox(height: 8),
            if (state.status == ExternalAccountsStateStatus.loading) ...[
              SmartShimmer(
                placeholders: [
                  ShimmerPlaceholder(
                    height: 100,
                    width: double.infinity,
                    borderRadius: 16,
                  )
                ],
              ),
              const SizedBox(height: 16),
            ] else if (state.status ==
                ExternalAccountsStateStatus.loadError) ...[
              InformationBlock.error("Gagal mendapatkan daftar akun terhubung"),
              const SizedBox(height: 8),
              TextButton.icon(
                  onPressed: () =>
                      context.read<ExternalAccountsCubit>().loadAccounts(),
                  label: Text("Muat ulang"),
                  icon: const Icon(Icons.refresh)),
              const SizedBox(height: 16),
            ] else ...[
              CustomCard(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CustomList(
                      items: state.accounts,
                      separatorHeight: 8,
                      emptyWidget: Container(
                          padding: const EdgeInsets.all(8),
                          child: InformationBlock.info(
                              "Belum ada akun terhubung, Hubungkan akun melalui halaman perusahaan terkait")),
                      itemBuilder: (item, _) => _Accounts(
                            externalUser: item,
                            isDetaching: state.status ==
                                    ExternalAccountsStateStatus.detachLoading &&
                                detachTargetLoading == item.id,
                            onDetach: detachTargetLoading == item.id
                                ? null
                                : () => context
                                    .read<ExternalAccountsCubit>()
                                    .detachAccount(item.id),
                          ))),
            ],
          ],
        );
      }),
    );
  }
}

class _Accounts extends StatelessWidget {
  final ExternalUserEntity externalUser;
  final bool isDetaching;
  final VoidCallback? onDetach;

  const _Accounts(
      {required this.externalUser,
      required this.isDetaching,
      required this.onDetach});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isDetaching) {
      return SmartShimmer();
    }

    return InkWell(
      onTap: () async {
        if (onDetach == null) {
          return;
        }

        final result = await showConfirmDialog(
            icon: AppIcon.detach,
            context: context,
            title: "Putuskan Koneksi",
            message:
                "Anda yakin ingin melepaskan koneksi akun anda di perusahaan ${externalUser.company.name}");
        if (result == true) {
          onDetach?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconBox.small(icon: AppIcon.company),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        externalUser.company.name,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        externalUser.externalEmail,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Terhubung pada ${DateFormat('d MMM yyyy', 'id_ID').format(externalUser.pairedAt.toLocal())}",
                  style: theme.textTheme.labelSmall,
                ))
          ],
        ),
      ),
    );
  }
}
