import 'package:open_meteo_flutter/data/models/city.dart';
import 'package:open_meteo_flutter/data/models/weather.dart';
import 'package:open_meteo_flutter/data/services/open_meteo_api_service.dart';

class WeatherRepository {
  WeatherRepository({required OpenMeteoApiService apiService})
      : _apiService = apiService;

  final OpenMeteoApiService _apiService;
  final Map<String, _CachedWeather> _cache = {};
  final List<City> _searchHistory = [];

  Duration cacheDuration = const Duration(minutes: 10);

  Future<WeatherData> getWeather({
    required double latitude,
    required double longitude,
    String? cityName,
    bool forceRefresh = false,
  }) async {
    final key = '${latitude.toStringAsFixed(3)},${longitude.toStringAsFixed(3)}';
    final now = DateTime.now();
    final cached = _cache[key];

    if (!forceRefresh && cached != null && now.difference(cached.timestamp) < cacheDuration) {
      return cached.data;
    }

    final weather = await _apiService.fetchWeather(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
    );
    _cache[key] = _CachedWeather(now, weather);
    return weather;
  }

  Future<List<City>> searchCities(String query) => _apiService.searchCities(query);

  List<City> get searchHistory => List.unmodifiable(_searchHistory);

  void addToHistory(City city) {
    _searchHistory.remove(city);
    _searchHistory.insert(0, city);
    if (_searchHistory.length > 8) {
      _searchHistory.removeRange(8, _searchHistory.length);
    }
  }
}

class _CachedWeather {
  _CachedWeather(this.timestamp, this.data);

  final DateTime timestamp;
  final WeatherData data;
}
