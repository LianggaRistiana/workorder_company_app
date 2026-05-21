import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
