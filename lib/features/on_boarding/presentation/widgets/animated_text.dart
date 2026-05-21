import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedTypingSubtitle
    extends StatefulWidget {
  final String title;

  final List<String> subtitles;

  const AnimatedTypingSubtitle({
    super.key,
    required this.title,
    required this.subtitles,
  });

  @override
  State<AnimatedTypingSubtitle> createState() =>
      _AnimatedTypingSubtitleState();
}

class _AnimatedTypingSubtitleState
    extends State<AnimatedTypingSubtitle> {
  String displayedText = "";

  int subtitleIndex = 0;

  int charIndex = 0;

  Timer? timer;

  bool deleting = false;

  bool waiting = false;

  @override
  void initState() {
    super.initState();

    _startTyping();
  }

  void _startTyping() {
    timer = Timer.periodic(
      const Duration(milliseconds: 60),
      (_) async {
        if (waiting) return;

        final currentText =
            widget.subtitles[subtitleIndex];

        if (!mounted) return;

        setState(() {
          if (!deleting) {
            if (charIndex < currentText.length) {
              displayedText +=
                  currentText[charIndex];

              charIndex++;
            } else {
              waiting = true;
            }
          } else {
            if (displayedText.isNotEmpty) {
              displayedText =
                  displayedText.substring(
                0,
                displayedText.length - 1,
              );
            } else {
              deleting = false;

              charIndex = 0;

              subtitleIndex =
                  (subtitleIndex + 1) %
                      widget.subtitles.length;
            }
          }
        });

        if (waiting) {
          await Future.delayed(
            const Duration(seconds: 2),
          );

          if (!mounted) return;

          waiting = false;

          deleting = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF8B5CF6),
              ],
            ).createShader(bounds);
          },
          child: Text(
            widget.title,
            style: theme.textTheme.headlineMedium
                ?.copyWith(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                displayedText,
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w700,
                    ),
              ),
            ),

            const _BlinkingCursor(),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() =>
      _BlinkingCursorState();
}

class _BlinkingCursorState
    extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: Text(
        "|",
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(
              color: const Color(
                0xFF8B5CF6,
              ),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}