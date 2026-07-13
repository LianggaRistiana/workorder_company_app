import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/claim/claim_invitation_code_cubit.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/claim/claim_invitation_code_state.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_preview_entity.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

class ClaimInvitationCodePage extends StatelessWidget {
  const ClaimInvitationCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClaimInvitationCodeCubit>(),
      child: BlocConsumer<ClaimInvitationCodeCubit, ClaimInvitationCodeState>(
        listener: (context, state) {
          if (state.status == ClaimInvitationCodeStatus.error) {
            context.showError(state.errorMessage ?? 'Terjadi kesalahan');
          }
          if (state.status == ClaimInvitationCodeStatus.claimed) {
            context.showSuccess('Selamat! Kamu berhasil bergabung ke perusahaan.');
            // Refresh user state so new role/company/position is reflected
            context.read<AuthBloc>().add(GetCurrentUserRequested());
            context.pop();
          }
        },
        builder: (context, state) {
          return _ClaimInvitationCodeView(state: state);
        },
      ),
    );
  }
}

class _ClaimInvitationCodeView extends StatefulWidget {
  final ClaimInvitationCodeState state;

  const _ClaimInvitationCodeView({required this.state});

  @override
  State<_ClaimInvitationCodeView> createState() =>
      _ClaimInvitationCodeViewState();
}

class _ClaimInvitationCodeViewState
    extends State<_ClaimInvitationCodeView> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _preview() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      context.showWarning('Masukkan kode terlebih dahulu');
      return;
    }
    context.read<ClaimInvitationCodeCubit>().preview(code);
  }

  void _claim() {
    context
        .read<ClaimInvitationCodeCubit>()
        .claim(_codeController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isPreviewing = state.status == ClaimInvitationCodeStatus.previewing;
    final isClaiming = state.status == ClaimInvitationCodeStatus.claiming;
    final preview = state.preview as InvitationCodePreviewEntity?;
    final hasPreviewed = state.status == ClaimInvitationCodeStatus.previewed;

    return Scaffold(
      appBar: AppBar(title: const Text('Klaim Kode Undangan')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            InformationBlock(
              message:
                  'Masukkan kode undangan yang kamu terima dari perusahaan untuk bergabung sebagai anggota.',
            ),
            const SizedBox(height: 20),
            CustomInputField(
              controller: _codeController,
              label: 'Kode Undangan',
              hint: 'Contoh: K7XM29AB',
              enabled: !isClaiming,
              onChanged: (_) {
                // Reset preview if user changes code
                if (hasPreviewed) {
                  context.read<ClaimInvitationCodeCubit>().reset();
                }
              },
            ),
            const SizedBox(height: 16),
            if (!hasPreviewed)
              ButtonWithLoadingState(
                icon: AppIcon.viewable,
                label: 'Lihat Detail Kode',
                isLoading: isPreviewing,
                onPressed: _preview,
              ),

            // Preview Card
            if (hasPreviewed && preview != null) ...[
              const SizedBox(height: 20),
              _PreviewCard(preview: preview),
              const SizedBox(height: 20),
              ButtonWithLoadingState(
                icon: AppIcon.approve,
                label: 'Konfirmasi & Bergabung',
                isLoading: isClaiming,
                onPressed: _claim,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  context.read<ClaimInvitationCodeCubit>().reset();
                },
                child: const Text('Ganti Kode'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final InvitationCodePreviewEntity preview;

  const _PreviewCard({required this.preview});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(AppIcon.invitation, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Detail Undangan',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Perusahaan',
              value: preview.company?.name ?? '-',
            ),
            const SizedBox(height: 8),
            _InfoRow(label: 'Peran', value: preview.roleDisplayName),
            if (preview.position != null) ...[
              const SizedBox(height: 8),
              _InfoRow(
                  label: 'Departemen', value: preview.position!.name),
            ],
            if (preview.expiresAt != null) ...[
              const SizedBox(height: 8),
              _InfoRow(
                label: 'Berlaku Hingga',
                value:
                    '${preview.expiresAt!.toLocal().day} ${_monthName(preview.expiresAt!.month)} ${preview.expiresAt!.year}',
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Kamu akan bergabung ke ${preview.company?.name ?? 'perusahaan ini'} sebagai ${preview.roleDisplayName}${preview.position != null ? ' di departemen ${preview.position!.name}' : ''}.',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return months[month - 1];
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
