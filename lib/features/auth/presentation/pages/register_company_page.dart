import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/auth/domain/entities/company_registration_entity.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_back_buttom.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class RegisterCompanyPage extends StatefulWidget {
  const RegisterCompanyPage({super.key});

  @override
  State<RegisterCompanyPage> createState() => _RegisterCompanyPageState();
}

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final registrationData = CompanyRegistrationEntity(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        companyName: _companyNameController.text.trim(),
      );

      context.read<AuthBloc>().add(
            CompanyRegistrationRequested(registrationData),
          );
    }
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_onFieldChanged);
    _nameController.addListener(_onFieldChanged);
    _companyNameController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _companyNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isFieldFilled() {
    return _emailController.text.isNotEmpty ||
        _nameController.text.isNotEmpty ||
        _companyNameController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          showConfirm: _isFieldFilled(),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            context.showError(state.message);
          }

          if (state is CompanyRegistrationSuccess) {
            context.showSuccess("Perusahaan berhasil terdaftar");

            context
                .go("${AppRoutes.login}?email=${_emailController.text.trim()}");
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Form(
                      key: _formKey,
                      child: _buildFormContent(),
                    ),
                  ),
                ),
                _buildRegisterButton(isLoading),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daftarkan Perusahaan Anda",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          "Mulai kelola Work Order secara terstruktur dan terintegrasi.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),

        /// =====================
        /// DATA AKUN ADMIN
        /// =====================
        Row(
          children: [
            const IconBox(
              icon: Icons.account_circle_outlined,
              paddingSize: 8,
              iconSize: 18,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              "Data Akun Admin",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        CustomInputField(
          label: "Nama Lengkap",
          controller: _nameController,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (value) => ValidatorUtils.validate(
            value,
            fieldName: "Nama",
            minLength: 6,
            [
              ValidatorType.required,
              ValidatorType.minLength,
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        CustomInputField(
          label: "Email",
          controller: _emailController,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: (value) => ValidatorUtils.validate(
            value,
            fieldName: "Email",
            [
              ValidatorType.required,
              ValidatorType.email,
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        CustomInputField(
          label: "Kata Sandi",
          controller: _passwordController,
          obscureText: !_showPassword,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
          validator: (value) => ValidatorUtils.validate(
            value,
            fieldName: "Kata Sandi",
            [
              ValidatorType.required,
              ValidatorType.password,
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        CustomInputField(
          label: "Konfirmasi Kata Sandi",
          controller: _confirmPasswordController,
          obscureText: !_showPassword,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
          validator: (value) => ValidatorUtils.validate(
            value,
            fieldName: "Konfirmasi Kata Sandi",
            matchValue: _passwordController.text,
            [
              ValidatorType.required,
              ValidatorType.match,
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        InformationBlock.info(
          "Akun ini akan terdaftar sebagai pemilik dan memiliki akses penuh terhadap sistem perusahaan.",
        ),

        const SizedBox(height: AppSpacing.xl),

        /// =====================
        /// DATA PERUSAHAAN
        /// =====================
        Row(
          children: [
            const IconBox(
              icon: Icons.home_work_outlined,
              paddingSize: 8,
              iconSize: 18,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              "Data Perusahaan",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        CustomInputField(
          label: "Nama Perusahaan",
          controller: _companyNameController,
          prefixIcon: const Icon(Icons.business_outlined),
          validator: (value) => ValidatorUtils.validate(
            value,
            fieldName: "Nama Perusahaan",
            [
              ValidatorType.required,
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        InformationBlock.info(
          "Pengaturan lanjutan dapat disesuaikan setelah proses pendaftaran selesai.",
        ),

        const SizedBox(height: AppSpacing.xl),

        Divider(),

        TextButton(
          onPressed: () {
            context.go(AppRoutes.login);
          },
          child: const Text("Saya sudah punya akun"),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onRegisterPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text("Daftarkan Perusahaan"),
      ),
    );
  }
}
