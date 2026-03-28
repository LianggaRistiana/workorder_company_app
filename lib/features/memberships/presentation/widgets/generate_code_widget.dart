import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_codes_generate_draft_entity.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/generate_code/generate_membership_code_cubit.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/generate_code/generate_membership_code_state.dart';

class GenerateCodeWidget extends StatefulWidget {
  const GenerateCodeWidget({super.key});

  @override
  State<GenerateCodeWidget> createState() => _GenerateCodeWidgetState();
}

class _GenerateCodeWidgetState extends State<GenerateCodeWidget> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onGenerate() {
    if (!_formKey.currentState!.validate()) return;

    final draft = MembershipCodesGenerateDraftEntity(
      prefix: _codeController.text.trim(),
      amount: int.parse(_amountController.text.trim()),
    );

    context.read<GenerateMembershipCodeCubit>().generateCode(draft);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenerateMembershipCodeCubit,
        GenerateMembershipCodeState>(
      listener: (context, state) {
        if (state.status == GenerateMembershipCodeStatus.success) {
          context.showSuccess("Kode berhasil digenerate");

          _codeController.clear();
          _amountController.clear();
          
          _formKey.currentState?.reset();
          
        }

        if (state.status == GenerateMembershipCodeStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      },
      builder: (context, state) {
        final isLoading = state.status == GenerateMembershipCodeStatus.loading;

        return CustomCard(
          margin: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Generate Kode Langganan",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),

                /// PREFIX
                CustomInputField(
                  label: "Kode",
                  controller: _codeController,
                  enabled: !isLoading,
                  validator: (value) => ValidatorUtils.validate(
                    value,
                    [
                      ValidatorType.required,
                      ValidatorType.minLength,
                      ValidatorType.maxLength,
                    ],
                    minLength: 3,
                    maxLength: 10,
                    fieldName: "Kode",
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                /// AMOUNT
                CustomInputField(
                  label: "Jumlah",
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  enabled: !isLoading,
                  validator: (value) => ValidatorUtils.validate(
                    value,
                    [
                      ValidatorType.required,
                      ValidatorType.number,
                      ValidatorType.minValue,
                    ],
                    minValue: 1,
                    fieldName: "Jumlah",
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isLoading ? null : _onGenerate,
                    child: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Generate"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
