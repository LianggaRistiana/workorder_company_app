import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:workorder_company_app/core/di/injection.dart';

import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_pairing/account_pairing_bloc.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_pairing/account_pairing_event.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_pairing/account_pairing_state.dart';

import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';

class AccountPairingPage extends StatelessWidget {
  final String companyId;

  const AccountPairingPage({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AccountPairingBloc>()
        ..add(
          AccountPairingStarted(companyId),
        ),
      child: _AccountPairingView(
        companyId,
      ),
    );
  }
}

class _AccountPairingView extends StatelessWidget {
  final String companyId;

  const _AccountPairingView(this.companyId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menghubungkan Akun"),
      ),
      body: BlocConsumer<AccountPairingBloc, AccountPairingState>(
        listenWhen: (previous, current) {
          return current is AccountPairingWaitingRedirect ||
              current is AccountPairingFailure ||
              current is AccountPairingSuccess;
        },
        listener: (context, state) async {
          if (state is AccountPairingWaitingRedirect) {
            context
                .read<AccountPairingBloc>()
                .add(const AccountRedirectLoginStarted());

            final uri = Uri.tryParse(state.redirectUrl);

            if (uri == null) {
              if (!context.mounted) return;

              context.showError("Redirect URL tidak valid");
              context.pop();
              return;
            }

            final canLaunch = await canLaunchUrl(uri);

            if (!canLaunch) {
              if (!context.mounted) return;

              context.showError(
                "Tidak dapat membuka halaman otorisasi",
              );

              context.pop();
              return;
            }

            await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          }

          if (state is AccountPairingFailure) {
            if (!context.mounted) return;

            context.showError(state.message);
            context.pop();
          }

          if (state is AccountPairingSuccess) {
            if (!context.mounted) return;

            context.showSuccess(state.message);
            context.pop(state.account);
          }
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildState(context, state),
          );
        },
      ),
    );
  }

  Widget _buildState(
    BuildContext context,
    AccountPairingState state,
  ) {
    if (state is AccountPairingInitial) {
      return const Center(
        key: ValueKey("loading"),
        child: AppLoading(
          message: "Menyiapkan pairing akun...",
        ),
      );
    }

    if (state is AccountPairingWaitingRedirect) {
      return const Center(
        key: ValueKey("redirect"),
        child: AppLoading(
          message: "Membuka halaman otorisasi...",
        ),
      );
    }

    if (state is AccountPairingWaitingExternalResult) {
      return const Center(
        key: ValueKey("external"),
        child: AppLoading(
          message: "Menunggu otorisasi dari aplikasi eksternal...",
        ),
      );
    }

    if (state is AccountPairingWaitingCompletion) {
      return const Center(
        key: ValueKey("completion"),
        child: AppLoading(
          message: "Menyelesaikan proses pairing...",
        ),
      );
    }

    if (state is AccountPairingSuccess) {
      return Center(
        key: const ValueKey("success"),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 88,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                "Berhasil",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state is AccountPairingFailure) {
      return Center(
        key: const ValueKey("failure"),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_rounded,
                size: 88,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                "Pairing Gagal",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  context.read<AccountPairingBloc>().add(
                        AccountPairingStarted(companyId),
                      );
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
