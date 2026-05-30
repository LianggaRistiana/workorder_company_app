// import 'dart:math';

// import 'package:flutter/material.dart';

// class AuroraBackground extends StatefulWidget {
//   const AuroraBackground({super.key});

//   @override
//   State<AuroraBackground> createState() =>
//       _AuroraBackgroundState();
// }

// class _AuroraBackgroundState
//     extends State<AuroraBackground>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return RepaintBoundary(
//       child: CustomPaint(
//         size: Size.infinite,
//         painter: _AuroraPainter(
//           animation: _controller,
//           surfaceColor: theme.colorScheme.surface,
//           isDark:
//               theme.brightness == Brightness.dark,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// class _AuroraPainter extends CustomPainter {
//   final Animation<double> animation;
//   final Color surfaceColor;
//   final bool isDark;

//   _AuroraPainter({
//     required this.animation,
//     required this.surfaceColor,
//     required this.isDark,
//   }) : super(repaint: animation);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final t = animation.value;

//     canvas.drawRect(
//       Offset.zero & size,
//       Paint()..color = surfaceColor,
//     );

//     final blueOpacity =
//         isDark ? 0.30 : 0.18;

//     final purpleOpacity =
//         isDark ? 0.28 : 0.16;

//     final violetOpacity =
//         isDark ? 0.22 : 0.12;

//     _drawGlow(
//       canvas,
//       center: Offset(
//         size.width * (
//           0.2 + sin(t * pi * 2) * 0.08
//         ),
//         size.height * 0.25,
//       ),
//       radius: 240,
//       color: const Color(0xFF2563EB)
//           .withOpacity(blueOpacity),
//     );

//     _drawGlow(
//       canvas,
//       center: Offset(
//         size.width * (
//           0.8 + cos(t * pi * 2) * 0.06
//         ),
//         size.height * 0.35,
//       ),
//       radius: 280,
//       color: const Color(0xFF7C3AED)
//           .withOpacity(purpleOpacity),
//     );

//     _drawGlow(
//       canvas,
//       center: Offset(
//         size.width * 0.5,
//         size.height * (
//           0.75 + sin(t * pi * 2) * 0.05
//         ),
//       ),
//       radius: 260,
//       color: const Color(0xFF9333EA)
//           .withOpacity(violetOpacity),
//     );

//     _drawParticles(
//       canvas,
//       size,
//       t,
//     );
//   }

//   void _drawGlow(
//     Canvas canvas, {
//     required Offset center,
//     required double radius,
//     required Color color,
//   }) {
//     final paint = Paint()
//       ..shader = RadialGradient(
//         colors: [
//           color,
//           Colors.transparent,
//         ],
//       ).createShader(
//         Rect.fromCircle(
//           center: center,
//           radius: radius,
//         ),
//       )
//       ..maskFilter = const MaskFilter.blur(
//         BlurStyle.normal,
//         100,
//       )
//       ..blendMode = BlendMode.plus;

//     canvas.drawCircle(
//       center,
//       radius,
//       paint,
//     );
//   }

//   void _drawParticles(
//     Canvas canvas,
//     Size size,
//     double t,
//   ) {
//     final random = Random(1);

//     for (int i = 0; i < 30; i++) {
//       final dx =
//           random.nextDouble() * size.width;

//       final baseDy =
//           random.nextDouble() * size.height;

//       final dy = baseDy +
//           sin(t * pi * 2 + i) * 8;

//       final radius =
//           random.nextDouble() * 2 + 1;

//       final paint = Paint()
//         ..color = Colors.white.withOpacity(
//           isDark ? 0.06 : 0.04,
//         )
//         ..maskFilter = const MaskFilter.blur(
//           BlurStyle.normal,
//           8,
//         );

//       canvas.drawCircle(
//         Offset(dx, dy),
//         radius,
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(
//     covariant _AuroraPainter oldDelegate,
//   ) {
//     return false;
//   }
// }
