import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/account_pairing_bloc.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/account_pairing_event.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/account_pairing_state.dart';
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
      create: (_) => sl<AccountPairingBloc>()..add(AccountPairingStarted()),
      child: const _AccountPairingView(),
    );
  }
}

/// =======================================================
/// VIEW
/// =======================================================

class _AccountPairingView extends StatelessWidget {
  const _AccountPairingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account Pairing")),
      body: BlocConsumer<AccountPairingBloc, AccountPairingState>(
        listener: (context, state) async {
          if (state is AccountPairingWaitingRedirect) {
            final url = Uri.parse(state.redirectUrl);

            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            }
          } else if (state is AccountPairingFailure) {
            context.showError(state.message);
          } else if (state is AccountPairingSuccess) {
            context.showSuccess(state.message);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is AccountPairingInitial) {
            return const Center(
                child: AppLoading(
              message: "Mendapatkan redirect URL...",
            ));
          }

          if (state is AccountPairingWaitingRedirect) {
            return const Center(
                child: AppLoading(
              message: "Menunggu redirect URL...",
            ));
          }

          if (state is AccountPairingWaitingExternalResult) {
            return const Center(
                child: AppLoading(
              message: "Menunggu otorisasi...",
            ));
          }

          if (state is AccountPairingWaitingCompletion) {
            return const Center(
                child: AppLoading(
              message: "Menyelesaikan pairing...",
            ));
          }

          if (state is AccountPairingSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 80, color: Colors.green),
                  const SizedBox(height: 12),
                  Text(state.message),
                ],
              ),
            );
          }

          if (state is AccountPairingFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 80, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.message),
                  const SizedBox(height: 12),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
