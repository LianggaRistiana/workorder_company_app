import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/otp_verification_entity.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;

  const VerifyOtpPage({super.key, required this.email});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage>
    with SingleTickerProviderStateMixin {
  static const int _otpLength = 6;
  static const int _resendCooldownSeconds = 60;

  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  int _resendCountdown = _resendCooldownSeconds;
  Timer? _resendTimer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = _resendCooldownSeconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String get _otpValue =>
      _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otpValue.length == _otpLength;

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      setState(() {});
    }
  }

  void _onSubmit() {
    if (!_isOtpComplete) return;

    context.read<AuthBloc>().add(
          OtpVerificationRequested(
            OtpVerificationEntity(
              email: widget.email,
              otp: _otpValue,
            ),
          ),
        );
  }

  void _onResend() {
    if (!_canResend) return;

    context.read<AuthBloc>().add(OtpResendRequested(widget.email));
    _startResendTimer();
  }

  void _clearAll() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    setState(() {});
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _shakeController.forward(from: 0);
          _clearAll();
          context.showError(state.message);
        }

        if (state is OtpVerificationSuccess) {
          context.showSuccess("Verifikasi berhasil! Silakan masuk.");
          context.go(AppRoutes.login);
        }

        if (state is OtpResendSuccess) {
          context.showSuccess("Kode OTP baru telah dikirim ke ${widget.email}");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      _buildIcon(colorScheme),
                      const SizedBox(height: AppSpacing.xl),
                      _buildHeader(textTheme),
                      const SizedBox(height: AppSpacing.sm),
                      _buildSubtitle(textTheme, colorScheme),
                      const SizedBox(height: AppSpacing.xl),
                      _buildOtpFields(colorScheme),
                      const SizedBox(height: AppSpacing.xl),
                      _buildResendSection(textTheme, colorScheme),
                    ],
                  ),
                ),
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.mark_email_read_outlined,
        size: 40,
        color: colorScheme.primary,
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Text(
      "Verifikasi Email",
      style: textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          "Masukkan kode 6 digit yang telah dikirim ke",
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          widget.email,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOtpFields(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final offsetX = _shakeController.isAnimating
            ? 12.0 * (0.5 - (_shakeAnimation.value % 1.0)).abs() * 2
            : 0.0;
        return Transform.translate(
          offset: Offset(offsetX, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_otpLength, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _OtpDigitField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              onChanged: (value) => _onDigitChanged(index, value),
              onKeyEvent: (event) => _onKeyEvent(index, event),
              colorScheme: colorScheme,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildResendSection(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          "Tidak menerima kode?",
          style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 6),
        if (_canResend)
          TextButton.icon(
            onPressed: _onResend,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text("Kirim ulang kode"),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer_outlined, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                "Kirim ulang dalam $_resendCountdown detik",
                style: textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return ButtonWithLoadingState(
            onPressed: _isOtpComplete ? _onSubmit : null,
            isLoading: isLoading,
            label: "Verifikasi",
            loadingLabel: "Memverifikasi...",
          );
        },
      ),
    );
  }
}

class _OtpDigitField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;
  final ColorScheme colorScheme;

  const _OtpDigitField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 58,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: onKeyEvent,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: controller.text.isNotEmpty
                ? colorScheme.primaryContainer.withOpacity(0.4)
                : Colors.transparent,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
