import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_meteo_flutter/core/utils/weather_code_mapper.dart';
import 'package:open_meteo_flutter/data/models/weather.dart';

class HourlyForecastList extends StatelessWidget {
  const HourlyForecastList({required this.hourly, super.key});

  final List<HourlyWeather> hourly;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = hourly[index];
          final visual = WeatherCodeMapper.map(item.weatherCode, isDay: true);
          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('HH:mm').format(item.time),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Icon(visual.icon, color: Colors.white),
                  const SizedBox(height: 6),
                  Text(
                    '${item.temperature.round()}°',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
