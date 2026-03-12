import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:open_meteo_flutter/core/utils/weather_code_mapper.dart';

class AnimatedWeatherIcon extends StatelessWidget {
  const AnimatedWeatherIcon({
    required this.visual,
    this.size = 96,
    super.key,
  });

  final WeatherVisualData visual;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      visual.icon,
      size: size,
      color: Colors.white,
    );

    return switch (visual.type) {
      WeatherVisualType.sunny => icon
          .animate(onPlay: (controller) => controller.repeat())
          .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2.seconds)
          .then()
          .scale(begin: const Offset(1.05, 1.05), end: const Offset(0.95, 0.95), duration: 2.seconds),
      WeatherVisualType.rainy => icon
          .animate(onPlay: (controller) => controller.repeat())
          .moveY(begin: -2, end: 2, duration: 800.ms)
          .then()
          .moveY(begin: 2, end: -2, duration: 800.ms),
      WeatherVisualType.storm => icon
          .animate(onPlay: (controller) => controller.repeat())
          .fadeIn(duration: 150.ms)
          .then(delay: 1200.ms)
          .fadeOut(duration: 150.ms)
          .then()
          .fadeIn(duration: 150.ms),
      _ => icon
          .animate(onPlay: (controller) => controller.repeat())
          .moveX(begin: -4, end: 4, duration: 2.seconds)
          .then()
          .moveX(begin: 4, end: -4, duration: 2.seconds),
    };
  }
}
