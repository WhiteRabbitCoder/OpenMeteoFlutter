import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_flutter/core/constants/api_constants.dart';
import 'package:open_meteo_flutter/data/models/city.dart';
import 'package:open_meteo_flutter/data/models/weather.dart';

class OpenMeteoApiService {
  const OpenMeteoApiService(this._client);

  final http.Client _client;

  Future<WeatherData> fetchWeather({
    required double latitude,
    required double longitude,
    String? cityName,
  }) async {
    final uri = Uri.parse(ApiConstants.weatherBaseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current_weather': 'true',
        'hourly':
            'apparent_temperature,relative_humidity_2m,precipitation_probability,weathercode,temperature_2m',
        'daily': 'weathercode,temperature_2m_max,temperature_2m_min',
        'forecast_days': '7',
        'timezone': 'auto',
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('No se pudo cargar el clima (${response.statusCode}).');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return WeatherData.fromJson(decoded, cityName: cityName);
  }

  Future<List<City>> searchCities(String query) async {
    if (query.trim().isEmpty) {
      return const [];
    }

    final uri = Uri.parse(ApiConstants.geocodingBaseUrl).replace(
      queryParameters: {
        'name': query,
        'count': '8',
        'language': 'es',
        'format': 'json',
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('No se pudo buscar la ciudad.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final results = decoded['results'] as List<dynamic>?;
    if (results == null) return const [];

    return results
        .whereType<Map<String, dynamic>>()
        .map(City.fromJson)
        .toList(growable: false);
  }
}
