import 'package:flutter_test/flutter_test.dart';
import 'package:open_meteo_flutter/core/utils/weather_code_mapper.dart';
import 'package:open_meteo_flutter/data/models/weather.dart';

void main() {
  test('WeatherData.fromJson parses current, hourly and daily data', () {
    final json = {
      'current_weather': {
        'time': '2026-03-12T10:00',
        'temperature': 24.2,
        'windspeed': 10.0,
        'weathercode': 0,
        'is_day': 1,
      },
      'hourly': {
        'time': [
          '2026-03-12T09:00',
          '2026-03-12T10:00',
          '2026-03-12T11:00',
        ],
        'temperature_2m': [23.1, 24.2, 25.0],
        'weathercode': [1, 0, 1],
        'apparent_temperature': [22.0, 23.5, 24.1],
        'relative_humidity_2m': [70, 65, 60],
        'precipitation_probability': [20, 10, 5],
      },
      'daily': {
        'time': ['2026-03-12', '2026-03-13'],
        'temperature_2m_min': [18.0, 17.0],
        'temperature_2m_max': [26.0, 27.0],
        'weathercode': [1, 2],
      },
    };

    final parsed = WeatherData.fromJson(json, cityName: 'Bogotá, CO');

    expect(parsed.cityName, 'Bogotá, CO');
    expect(parsed.current.temperature, 24.2);
    expect(parsed.current.apparentTemperature, 23.5);
    expect(parsed.current.humidity, 65);
    expect(parsed.hourly, hasLength(2));
    expect(parsed.daily, hasLength(2));
  });

  test('WeatherCodeMapper maps storm code correctly', () {
    final visual = WeatherCodeMapper.map(95, isDay: true);
    expect(visual.type, WeatherVisualType.storm);
    expect(visual.description, 'Tormenta');
  });
}
