import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      context.read<AuthBloc>().add(
            LoginRequested(email, password),
          );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final uri = GoRouterState.of(context).uri;
    final email = uri.queryParameters['email'];

    if (email != null) {
      _emailController.text = email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            debugPrint("Logging in...");
          } else if (state is Authenticated) {
            context.go("/home");
          } else if (state is AuthError) {
            context.showError(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Masuk",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 32,
                            ),
                      ),
                      Text(
                          "Masukan Email dan Kata Sandi Anda untuk masuk ke aplikasi.",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      CustomInputField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        label: "Email",
                        prefixIcon: const Icon(LucideIcons.mail),
                        validator: (value) {
                          // gunakan ValidatorUtils + placeholder TODO
                          final result = ValidatorUtils.validate(
                            value,
                            fieldName: "Email",
                            [ValidatorType.required, ValidatorType.email],
                          );
                          return result;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        label: "Kata Sandi",
                        prefixIcon: const Icon(LucideIcons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? LucideIcons.eye
                                : LucideIcons.eyeOff,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          final result = ValidatorUtils.validate(
                            value,
                            fieldName: "Kata Sandi",
                            [ValidatorType.required],
                          );
                          return result;
                        },
                      ),
                      const SizedBox(height: 32),
                      ButtonWithLoadingState(
                          onPressed: _onLoginPressed,
                          isLoading: isLoading,
                          icon: AppIcon.login,
                          label: "Masuk"),
                      TextButton(
                        onPressed: () {
                          // Logger().d(GoRouterState.of(context).uri.toString());
                          GoRouter.of(context).go(AppRoutes.register);
                        },
                        child: Text("Buat akun baru"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
