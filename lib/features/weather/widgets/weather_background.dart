import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_meteo_flutter/core/utils/weather_code_mapper.dart';

class WeatherBackground extends StatelessWidget {
  const WeatherBackground({required this.visual, super.key});

  final WeatherVisualData visual;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: visual.gradient,
            ),
          ),
        ),
        CustomPaint(painter: _ParticlesPainter(visual.type)),
      ],
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  _ParticlesPainter(this.type);

  final WeatherVisualType type;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.28);
    final random = Random(type.index + size.width.floor());

    final count = switch (type) {
      WeatherVisualType.rainy => 70,
      WeatherVisualType.storm => 55,
      WeatherVisualType.night => 60,
      _ => 32,
    };

    for (var i = 0; i < count; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      if (type == WeatherVisualType.rainy || type == WeatherVisualType.storm) {
        canvas.drawLine(Offset(dx, dy), Offset(dx - 2, dy + 10), paint..strokeWidth = 1.2);
      } else {
        canvas.drawCircle(Offset(dx, dy), random.nextDouble() * 2 + 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.type != type;
  }
}
