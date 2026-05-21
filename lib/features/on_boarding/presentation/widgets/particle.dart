import 'dart:math';

import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  double radius;
  Color color;

  Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
  });

  void update(Size size) {
    position += velocity;

    if (position.dx < -10) {
      position = Offset(
        size.width + 10,
        position.dy,
      );
    }

    if (position.dx > size.width + 10) {
      position = Offset(
        -10,
        position.dy,
      );
    }

    if (position.dy < -10) {
      position = Offset(
        position.dx,
        size.height + 10,
      );
    }

    if (position.dy > size.height + 10) {
      position = Offset(
        position.dx,
        -10,
      );
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  final Animation<double> repaintAnimation;

  ParticlePainter({
    required this.particles,
    required this.repaintAnimation,
  }) : super(repaint: repaintAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()..color = particle.color;

      canvas.drawCircle(
        particle.position,
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant ParticlePainter oldDelegate,
  ) {
    return false;
  }
}

class ParticleBackground extends StatefulWidget {
  final int particleCount;

  const ParticleBackground({
    super.key,
    this.particleCount = 50,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  late final List<Particle> particles;

  final random = Random();

  Size screenSize = Size.zero;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    );

    particles = [];

    controller
      ..addListener(_updateParticles)
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    screenSize = MediaQuery.sizeOf(context);

    if (particles.isEmpty) {
      final colors = [
        const Color(0xFF3B82F6),
        const Color(0xFF6366F1),
        const Color(0xFF8B5CF6),
        const Color(0xFFA855F7),
      ];

      particles.addAll(
        List.generate(
          widget.particleCount,
          (_) => Particle(
              position: Offset(
                random.nextDouble() * screenSize.width,
                random.nextDouble() * screenSize.height,
              ),
              velocity: Offset(
                (random.nextDouble() - 0.5) * 0.18,
                (random.nextDouble() - 0.5) * 0.18,
              ),
              radius: random.nextDouble() * 2 + 1,
              color: colors[random.nextInt(
                colors.length,
              )]
                  .withValues(
                alpha: random.nextDouble() * 0.5 + 0.2,
              )),
        ),
      );
    }
  }

  void _updateParticles() {
    for (final particle in particles) {
      particle.update(screenSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          isComplex: true,
          willChange: true,
          size: Size.infinite,
          painter: ParticlePainter(
            particles: particles,
            repaintAnimation: controller,
          ),
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
