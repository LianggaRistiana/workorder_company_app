import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Particle model – each blob is a large, soft, translucent colour orb.
// ---------------------------------------------------------------------------

class _Blob {
  Offset position;
  Offset velocity;

  /// Base radius — these are large blobs that fill a significant portion of
  /// the screen.
  final double radius;

  /// Each blob breathes at a slightly different phase & speed.
  final double pulsePhase;
  final double pulseSpeed;

  final Color color;

  _Blob({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.pulsePhase,
    required this.pulseSpeed,
    required this.color,
  });

  double liveRadius(double t) {
    final pulse = sin(t * 2 * pi * pulseSpeed + pulsePhase);
    return radius * (1 + pulse * 0.12);
  }

  void update(Size size) {
    position += velocity;
    _wrap(size);
  }

  void _wrap(Size size) {
    const m = 80.0;
    if (position.dx < -m) position = Offset(size.width + m, position.dy);
    if (position.dx > size.width + m) position = Offset(-m, position.dy);
    if (position.dy < -m) position = Offset(position.dx, size.height + m);
    if (position.dy > size.height + m) position = Offset(position.dx, -m);
  }
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

class _BlobPainter extends CustomPainter {
  final List<_Blob> blobs;
  final Animation<double> animation;

  _BlobPainter({required this.blobs, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;

    for (final blob in blobs) {
      final r = blob.liveRadius(t);

      // Soft radial gradient — opaque colour at center, fully transparent edge.
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            blob.color.withValues(alpha: 0.55),
            blob.color.withValues(alpha: 0.18),
            blob.color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: blob.position, radius: r));

      canvas.drawCircle(blob.position, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlobPainter old) => false;
}
// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class ParticleBackground extends StatefulWidget {
  /// Ignored – always renders exactly 3 glass blobs.
  // ignore: unused_field
  final int particleCount;

  const ParticleBackground({super.key, this.particleCount = 3});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Blob> _blobs;

  Size _screenSize = Size.zero;
  bool _initialized = false;

  /// Exactly 3 hand-picked glass colours — indigo, teal, violet.
  static const _colors = [
    Color(0xFF6366F1), // indigo
    Color(0xFF14B8A6), // teal
    Color(0xFF8B5CF6), // violet
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _blobs = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.sizeOf(context);

    if (!_initialized && _screenSize != Size.zero) {
      _initialized = true;
      _spawnBlobs();
    }
  }

  void _spawnBlobs() {
    final rng = Random(42); // fixed seed → deterministic layout
    final w = _screenSize.width;
    final h = _screenSize.height;

    // Spread the 3 blobs across the screen quadrants for balanced coverage.
    final positions = [
      Offset(w * 0.25, h * 0.25),
      Offset(w * 0.75, h * 0.55),
      Offset(w * 0.40, h * 0.80),
    ];

    for (int i = 0; i < 3; i++) {
      final angle = rng.nextDouble() * 2 * pi;
      final speed = 0.06 + rng.nextDouble() * 0.06; // very slow drift

      _blobs.add(_Blob(
        position: positions[i],
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        radius: w * (0.38 + rng.nextDouble() * 0.12), // 38–50% of screen width
        pulsePhase: i * (2 * pi / 3), // evenly phase-staggered
        pulseSpeed: 0.25 + rng.nextDouble() * 0.15,
        color: _colors[i],
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            for (final b in _blobs) {
              b.update(_screenSize);
            }
            return ImageFiltered(
              // The heavy Gaussian blur is what creates the frosted-glass look.
              imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: CustomPaint(
                isComplex: true,
                willChange: true,
                size: Size.infinite,
                painter: _BlobPainter(
                  blobs: _blobs,
                  animation: _controller,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
