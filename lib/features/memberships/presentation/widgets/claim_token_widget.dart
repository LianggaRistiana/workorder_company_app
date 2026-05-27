import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/claim/claim_membership_code_cubit.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/claim/claim_membership_code_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class ClaimTokenWidget extends StatelessWidget {
  final String companyId;
  final VoidCallback? onClaimSuccess;

  const ClaimTokenWidget({
    super.key,
    required this.companyId,
    this.onClaimSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ClaimMembershipCodeCubit, ClaimMembershipCodeState>(
      listener: (context, state) {
        if (state.status == ClaimMembershipCodeStatus.success) {
          context.showSuccess("Berhasil klaim kode keanggotaan");
          if (onClaimSuccess != null) {
            onClaimSuccess?.call();
          }
        }

        if (state.status == ClaimMembershipCodeStatus.failure) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      },
      builder: (context, state) {
        final externalUser = state.externalUser;
        if (state.status == ClaimMembershipCodeStatus.loading) {
          return SmartShimmer(
            key: const ValueKey('loading'),
            placeholders: [
              ShimmerPlaceholder(
                  height: 60, width: double.infinity, borderRadius: 50),
            ],
          );
        } else if (externalUser != null) {
          return SizedBox.shrink();
        }

        return DashedButton(
          borderRadius: AppRadius.large,
          icon: AppIcon.memberCode,
          height: 52,
          borderColor: theme.colorScheme.primary,
          color: theme.colorScheme.primary,
          title: "Klaim Kode Keanggotaan",
          onTap: () {
            servicePriceEditorDialog(context, (token) {
              context.read<ClaimMembershipCodeCubit>().claim(
                    token,
                    companyId,
                  );
            });
          },
        );
      },
    );
  }

  void servicePriceEditorDialog(
    BuildContext context,
    void Function(String token) onSubmit,
  ) {
    final controller = TextEditingController();

    showAppDialog(
      context,
      header: Row(
        children: [
          IconBox.small(icon: AppIcon.memberCode),
          const SizedBox(width: 8),
          Text(
            "Klaim Kode Keanggotaan",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InformationBlock.info(
            "Masukan token keanggotaan anda dari perusahaan ini",
          ),
          const SizedBox(height: 16),
          CustomInputField(
            controller: controller,
            label: "Token keanggotaan",
          ),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => context.pop(),
            child: const Text("Batal"),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () {
              final value = controller.text;

              if (value.isEmpty) {
                context.showError("Token kosong");
                return;
              }

              context.pop();
              onSubmit(value);
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
