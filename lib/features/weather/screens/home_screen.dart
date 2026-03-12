import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_meteo_flutter/core/utils/weather_code_mapper.dart';
import 'package:open_meteo_flutter/data/models/city.dart';
import 'package:open_meteo_flutter/data/models/weather.dart';
import 'package:open_meteo_flutter/features/weather/providers/weather_providers.dart';
import 'package:open_meteo_flutter/features/weather/screens/search_screen.dart';
import 'package:open_meteo_flutter/features/weather/widgets/current_conditions_grid.dart';
import 'package:open_meteo_flutter/features/weather/widgets/daily_forecast_list.dart';
import 'package:open_meteo_flutter/features/weather/widgets/hourly_forecast_list.dart';
import 'package:open_meteo_flutter/features/weather/widgets/weather_background.dart';
import 'package:open_meteo_flutter/features/weather/widgets/weather_header_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(selectedWeatherProvider);

    return weatherState.when(
      data: (weather) {
        if (weather == null) {
          return _NoLocationView(
            onSearchPressed: () => _openSearch(context, ref),
          );
        }
        return _WeatherView(
          weather: weather,
          onSearchPressed: () => _openSearch(context, ref),
          onRefresh: () => ref.invalidate(selectedWeatherProvider),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('No fue posible cargar el clima.\n$error', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(selectedWeatherProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSearch(BuildContext context, WidgetRef ref) async {
    final city = await Navigator.of(context).push<City>(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
    if (city != null) {
      ref.read(selectedCityProvider.notifier).state = city;
      ref.invalidate(selectedWeatherProvider);
    }
  }
}

class _NoLocationView extends StatelessWidget {
  const _NoLocationView({required this.onSearchPressed});

  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B79A1), Color(0xFF283E51)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_off, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'No se pudo obtener la ubicación.\nBusca una ciudad para ver el clima.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onSearchPressed,
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar ciudad'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeatherView extends StatelessWidget {
  const _WeatherView({
    required this.weather,
    required this.onSearchPressed,
    required this.onRefresh,
  });

  final WeatherData weather;
  final VoidCallback onSearchPressed;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final visual = WeatherCodeMapper.map(
      weather.current.weatherCode,
      isDay: weather.current.isDay,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: onSearchPressed, icon: const Icon(Icons.search)),
          IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          WeatherBackground(visual: visual),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                WeatherHeaderCard(
                  cityName: weather.cityName ?? 'Ubicación actual',
                  weather: weather,
                  visual: visual,
                ),
                const SizedBox(height: 12),
                CurrentConditionsGrid(current: weather.current),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Pronóstico por horas (24h)',
                  child: HourlyForecastList(hourly: weather.hourly),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Pronóstico por días (7 días)',
                  child: DailyForecastList(daily: weather.daily),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
