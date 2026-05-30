import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/on_boarding/presentation/widgets/animated_text.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 56),

              // App Icon
              _AppLogo(colorScheme: colorScheme),

              const SizedBox(height: 32),

              // Title + Animated Subtitle
              SizedBox(
                height: 110,
                child: AnimatedTypingSubtitle(
                  title: "Workorder App",
                  subtitles: [
                    "Konfigurasi layanan dinamis",
                    "Ajukan permintaan layanan",
                    "Monitoring teknisi",
                    "AI Powered FAQ System",
                    "Integrasi sistem eksternal",
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                "Platform pengelolaan work order yang cerdas, efisien, dan terintegrasi untuk tim Anda.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withAlpha(55),
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 40),

              // Divider label
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: colorScheme.outlineVariant,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Fitur Unggulan",
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: colorScheme.outlineVariant,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Feature chips
              _Features(colorScheme: colorScheme, theme: theme),

              const Spacer(),

              // CTA Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        theme.floatingActionButtonTheme.backgroundColor,
                    foregroundColor:
                        theme.floatingActionButtonTheme.foregroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    context.go(AppRoutes.login);
                  },
                  child: const Text("Mulai Sekarang"),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── App Logo ───────────────────────────────────────────────────────────────

class _AppLogo extends StatelessWidget {
  final ColorScheme colorScheme;

  const _AppLogo({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Image.asset(
        "assets/icon/app_icon.png",
        fit: BoxFit.contain,
      ),
    );
  }
}

// ─── Feature List ────────────────────────────────────────────────────────────

class _Features extends StatelessWidget {
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _Features({required this.colorScheme, required this.theme});

  static const List<_FeatureItem> _features = [
    _FeatureItem(title: "Manajemen Work Order", icon: AppIcon.workOrder),
    _FeatureItem(title: "Assign Teknisi", icon: AppIcon.user),
    _FeatureItem(title: "Approval", icon: AppIcon.approve),
    _FeatureItem(title: "Notifikasi Real-time", icon: AppIcon.notification),
    _FeatureItem(title: "Riwayat Pekerjaan", icon: AppIcon.history),
    _FeatureItem(title: "Laporan", icon: AppIcon.workReport),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _features.map((feature) {
        return _FeatureChip(
          feature: feature,
          colorScheme: colorScheme,
          theme: theme,
        );
      }).toList(),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final _FeatureItem feature;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _FeatureChip({
    required this.feature,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            feature.icon,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 7),
          Text(
            feature.title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final String title;
  final dynamic icon;

  const _FeatureItem({
    required this.title,
    required this.icon,
  });
}
