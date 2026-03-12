import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_meteo_flutter/core/utils/weather_code_mapper.dart';
import 'package:open_meteo_flutter/data/models/weather.dart';
import 'package:open_meteo_flutter/features/weather/widgets/animated_weather_icon.dart';

class WeatherHeaderCard extends StatelessWidget {
  const WeatherHeaderCard({
    required this.cityName,
    required this.weather,
    required this.visual,
    super.key,
  });

  final String cityName;
  final WeatherData weather;
  final WeatherVisualData visual;

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              cityName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${current.temperature.round()}°',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              visual.description,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            AnimatedWeatherIcon(visual: visual, size: 84),
            const SizedBox(height: 10),
            Text(
              DateFormat('EEEE d MMM, HH:mm', 'es').format(current.time),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
