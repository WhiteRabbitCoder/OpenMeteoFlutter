import 'package:flutter/material.dart';
import 'package:open_meteo_flutter/data/models/weather.dart';

class CurrentConditionsGrid extends StatelessWidget {
  const CurrentConditionsGrid({required this.current, super.key});

  final CurrentWeather current;

  @override
  Widget build(BuildContext context) {
    final entries = <({IconData icon, String label, String value})>[
      (icon: Icons.thermostat, label: 'Sensación', value: '${current.apparentTemperature.round()}°'),
      (icon: Icons.water_drop, label: 'Humedad', value: '${current.humidity}%'),
      (icon: Icons.air, label: 'Viento', value: '${current.windSpeed.round()} km/h'),
      (icon: Icons.umbrella, label: 'Lluvia', value: '${current.rainProbability}%'),
    ];

    return GridView.builder(
      itemCount: entries.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final item = entries[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(item.icon, color: Colors.white),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label, style: const TextStyle(color: Colors.white70)),
                    Text(
                      item.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
