import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:open_meteo_flutter/data/models/city.dart';
import 'package:open_meteo_flutter/data/models/weather.dart';
import 'package:open_meteo_flutter/data/repositories/weather_repository.dart';
import 'package:open_meteo_flutter/data/services/open_meteo_api_service.dart';
import 'package:permission_handler/permission_handler.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final openMeteoApiServiceProvider = Provider<OpenMeteoApiService>((ref) {
  return OpenMeteoApiService(ref.watch(httpClientProvider));
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository(apiService: ref.watch(openMeteoApiServiceProvider));
});

final selectedCityProvider = StateProvider<City?>((ref) => null);
final citySearchQueryProvider = StateProvider<String>((ref) => '');
final searchHistoryRefreshProvider = StateProvider<int>((ref) => 0);

final searchHistoryProvider = Provider<List<City>>((ref) {
  ref.watch(searchHistoryRefreshProvider);
  return ref.watch(weatherRepositoryProvider).searchHistory;
});

final citySearchResultsProvider = FutureProvider.autoDispose<List<City>>((ref) async {
  final query = ref.watch(citySearchQueryProvider);
  if (query.trim().length < 2) {
    return const [];
  }

  var disposed = false;
  ref.onDispose(() => disposed = true);

  await Future<void>.delayed(const Duration(milliseconds: 300));
  if (disposed) {
    return const [];
  }

  return ref.watch(weatherRepositoryProvider).searchCities(query);
});

final locationProvider = FutureProvider<Position?>((ref) async {
  final permission = await Permission.locationWhenInUse.request();
  if (!permission.isGranted) {
    return null;
  }

  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  return Geolocator.getCurrentPosition();
});

final selectedWeatherProvider = FutureProvider<WeatherData?>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);
  final repository = ref.watch(weatherRepositoryProvider);

  if (selectedCity != null) {
    return repository.getWeather(
      latitude: selectedCity.latitude,
      longitude: selectedCity.longitude,
      cityName: selectedCity.fullName,
    );
  }

  final position = await ref.watch(locationProvider.future);
  if (position == null) {
    return null;
  }

  return repository.getWeather(
    latitude: position.latitude,
    longitude: position.longitude,
    cityName: 'Ubicación actual',
  );
});
