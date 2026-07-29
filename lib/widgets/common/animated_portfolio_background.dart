import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/portfolio_theme.dart';

class AnimatedPortfolioBackground extends StatefulWidget {
  const AnimatedPortfolioBackground({super.key});

  @override
  State<AnimatedPortfolioBackground> createState() =>
      _AnimatedPortfolioBackgroundState();
}

class _AnimatedPortfolioBackgroundState
    extends State<AnimatedPortfolioBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
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
          builder: (context, _) {
            final phase = _controller.value * math.pi * 2;
            return Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: PortfolioColors.background),
                CustomPaint(painter: _GridPainter()),
                Positioned(
                  left: -120 + math.sin(phase) * 45,
                  top: 50 + math.cos(phase) * 35,
                  child: const _Glow(
                    size: 420,
                    color: PortfolioColors.secondary,
                  ),
                ),
                Positioned(
                  right: -150 + math.cos(phase) * 55,
                  top: 330 + math.sin(phase) * 45,
                  child: const _Glow(
                    size: 500,
                    color: PortfolioColors.primary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.022)
      ..strokeWidth = 1;
    const step = 54.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
