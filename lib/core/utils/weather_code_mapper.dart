import 'package:flutter/material.dart';

enum WeatherVisualType { sunny, cloudy, rainy, storm, snowy, foggy, night }

class WeatherVisualData {
  const WeatherVisualData({
    required this.description,
    required this.icon,
    required this.gradient,
    required this.type,
  });

  final String description;
  final IconData icon;
  final List<Color> gradient;
  final WeatherVisualType type;
}

class WeatherCodeMapper {
  const WeatherCodeMapper._();

  static WeatherVisualData map(int code, {required bool isDay}) {
    if (!isDay) {
      return const WeatherVisualData(
        description: 'Noche despejada',
        icon: Icons.nightlight_round,
        gradient: [Color(0xFF0B1026), Color(0xFF283C63)],
        type: WeatherVisualType.night,
      );
    }

    if (code == 0) {
      return const WeatherVisualData(
        description: 'Soleado',
        icon: Icons.wb_sunny_rounded,
        gradient: [Color(0xFFFFD55A), Color(0xFFFF8A65)],
        type: WeatherVisualType.sunny,
      );
    }

    if (code >= 1 && code <= 3) {
      return const WeatherVisualData(
        description: 'Parcialmente nublado',
        icon: Icons.cloud_queue_rounded,
        gradient: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
        type: WeatherVisualType.cloudy,
      );
    }

    if (code == 45 || code == 48) {
      return const WeatherVisualData(
        description: 'Niebla',
        icon: Icons.cloud,
        gradient: [Color(0xFFB0BEC5), Color(0xFF90A4AE)],
        type: WeatherVisualType.foggy,
      );
    }

    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return const WeatherVisualData(
        description: 'Lluvia',
        icon: Icons.grain,
        gradient: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
        type: WeatherVisualType.rainy,
      );
    }

    if (code >= 71 && code <= 77) {
      return const WeatherVisualData(
        description: 'Nieve',
        icon: Icons.ac_unit,
        gradient: [Color(0xFFBBD2C5), Color(0xFF536976)],
        type: WeatherVisualType.snowy,
      );
    }

    if (code >= 95) {
      return const WeatherVisualData(
        description: 'Tormenta',
        icon: Icons.thunderstorm,
        gradient: [Color(0xFF373B44), Color(0xFF4286F4)],
        type: WeatherVisualType.storm,
      );
    }

    return const WeatherVisualData(
      description: 'Clima variable',
      icon: Icons.wb_cloudy,
      gradient: [Color(0xFF74EBD5), Color(0xFFACB6E5)],
      type: WeatherVisualType.cloudy,
    );
  }
}
