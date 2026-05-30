import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/on_boarding/presentation/widgets/animated_text.dart';
import 'package:workorder_company_app/features/on_boarding/presentation/widgets/particle.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: ParticleBackground(),
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 100,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        padding: const EdgeInsets.all(
                          8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(
                            24,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withAlpha(
                              20,
                            ),
                          ),
                        ),
                        child: Image.asset(
                          "assets/icon/app_icon.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 120,
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
                      const SizedBox(height: 8),
                      _Features(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            theme.floatingActionButtonTheme.backgroundColor,
                        foregroundColor:
                            theme.floatingActionButtonTheme.foregroundColor,
                      ),
                      onPressed: () {
                        context.go(
                          AppRoutes.login,
                        );
                      },
                      child: const Text(
                        "Mulai",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Features extends StatelessWidget {
  const _Features();

  static const List<_FeatureItem> _features = [
    _FeatureItem(
      title: "Manajemen Work Order",
      icon: AppIcon.workOrder,
    ),
    _FeatureItem(
      title: "Assign Teknisi",
      icon: AppIcon.user,
    ),
    _FeatureItem(
      title: "Approval",
      icon: AppIcon.approve,
    ),
    _FeatureItem(
      title: "Notifikasi Real-time",
      icon: AppIcon.notification,
    ),
    _FeatureItem(
      title: "Riwayat Pekerjaan",
      icon: AppIcon.history,
    ),
    _FeatureItem(
      title: "Laporan",
      icon: AppIcon.workReport,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _features.map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                feature.icon,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                feature.title,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      }).toList(),
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
