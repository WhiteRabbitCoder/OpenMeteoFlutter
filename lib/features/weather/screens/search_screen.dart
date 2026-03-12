import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_meteo_flutter/data/models/city.dart';
import 'package:open_meteo_flutter/features/weather/providers/weather_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(citySearchQueryProvider);
    final results = ref.watch(citySearchResultsProvider);
    final history = ref.watch(searchHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar ciudad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) => ref.read(citySearchQueryProvider.notifier).state = value,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Ej: Medellín, Madrid, Tokyo...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: query.trim().isEmpty
                  ? _CityList(
                      title: 'Historial reciente',
                      cities: history,
                      onSelected: _selectCity,
                    )
                  : results.when(
                      data: (cities) => _CityList(
                        title: 'Resultados',
                        cities: cities,
                        onSelected: _selectCity,
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(
                        child: Text('Error buscando ciudades: $error'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectCity(City city) {
    ref.read(weatherRepositoryProvider).addToHistory(city);
    ref.read(searchHistoryRefreshProvider.notifier).state++;
    Navigator.of(context).pop(city);
  }
}

class _CityList extends StatelessWidget {
  const _CityList({
    required this.title,
    required this.cities,
    required this.onSelected,
  });

  final String title;
  final List<City> cities;
  final ValueChanged<City> onSelected;

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) {
      return const Center(child: Text('No hay ciudades para mostrar.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: cities.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final city = cities[index];
              return ListTile(
                title: Text(city.name),
                subtitle: Text(
                  city.region == null ? city.country : '${city.region}, ${city.country}',
                ),
                onTap: () => onSelected(city),
              );
            },
          ),
        ),
      ],
    );
  }
}
