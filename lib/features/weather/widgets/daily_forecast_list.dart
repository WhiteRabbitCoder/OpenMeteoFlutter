import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_meteo_flutter/core/utils/weather_code_mapper.dart';
import 'package:open_meteo_flutter/data/models/weather.dart';

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({required this.daily, super.key});

  final List<DailyWeather> daily;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: daily
          .map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  DateFormat('EEE d', 'es').format(item.date),
                  style: const TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  WeatherCodeMapper.map(item.weatherCode, isDay: true).icon,
                  color: Colors.white,
                ),
                trailing: Text(
                  '${item.minTemp.round()}° / ${item.maxTemp.round()}°',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
