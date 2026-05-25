import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/claim/claim_membership_code_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/claim/claim_membership_code_cubit.dart';

@Deprecated("we're no longer use this feature")
class ClaimMembershipCodePage extends StatelessWidget {
  const ClaimMembershipCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClaimMembershipCodeCubit>(),
      child: const _ClaimMembershipCodeView(),
    );
  }
}

class _ClaimMembershipCodeView extends StatefulWidget {
  const _ClaimMembershipCodeView();

  @override
  State<_ClaimMembershipCodeView> createState() =>
      _ClaimMembershipCodeViewState();
}

class _ClaimMembershipCodeViewState extends State<_ClaimMembershipCodeView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context
        .read<ClaimMembershipCodeCubit>()
        .claim(_codeController.text.trim(), "dummy-id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Claim Membership Code")),
      body: BlocConsumer<ClaimMembershipCodeCubit, ClaimMembershipCodeState>(
        listener: (context, state) {
          if (state.status == ClaimMembershipCodeStatus.success) {
            context.showSuccess("Kode berhasil diklaim");

            _codeController.clear();

            context.read<ClaimMembershipCodeCubit>().reset();
          }
        },
        builder: (context, state) {
          final isLoading = state.status == ClaimMembershipCodeStatus.loading;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInputField(
                    label: "Kode Membership",
                    hint: "Masukkan kode",
                    controller: _codeController,
                    enabled: !isLoading,
                    errorText: state.status == ClaimMembershipCodeStatus.failure
                        ? state.errorMessage
                        : null,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Kode tidak boleh kosong";
                      }
                      return null;
                    },
                    onEditingComplete: _submit,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Claim"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
