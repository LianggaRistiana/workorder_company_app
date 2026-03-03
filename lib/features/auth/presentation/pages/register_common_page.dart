import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class RegisterCommonPage extends StatefulWidget {
  final UserRole role;
  const RegisterCommonPage({super.key, required this.role});

  @override
  State<RegisterCommonPage> createState() => _RegisterCommonPageState();
}

class _RegisterCommonPageState extends State<RegisterCommonPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool isLoading = false;

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);

      // TODO: Trigger Bloc / API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: _buildFormContent(),
                ),
              ),
            ),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: AppSpacing.xl),
        _buildAccountSection(),
        const SizedBox(height: AppSpacing.xl),
        Divider(),
        TextButton(
          onPressed: () {
            context.go(AppRoutes.login);
          },
          child: Text("Saya sudah punya akun"),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daftarkan Akun Anda",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        // Text(
        //   "Mulai kelola Work Order secara terstruktur dan terintegrasi.",
        //   style: Theme.of(context).textTheme.bodyMedium,
        // ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconBox(
              icon: widget.role == UserRole.staffUnassigned
                  ? Icons.work_outline
                  : Icons.account_circle_outlined,
              paddingSize: 8,
              iconSize: 18,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              widget.role == UserRole.staffUnassigned
                  ? "Pegawai Perusahaan"
                  : "Kustomer",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        CustomInputField(
          label: "Nama Lengkap",
          controller: _nameController,
          prefixIcon: const Icon(Icons.person_outline),
          // backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(10),
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
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withAlpha(1),
      ),
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
            : const Text("Daftarkan akun"),
      ),
    );
  }
}
