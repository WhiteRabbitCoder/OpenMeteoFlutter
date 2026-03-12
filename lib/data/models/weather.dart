class CurrentWeather {
  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.windSpeed,
    required this.humidity,
    required this.rainProbability,
    required this.weatherCode,
    required this.isDay,
  });

  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final double windSpeed;
  final int humidity;
  final int rainProbability;
  final int weatherCode;
  final bool isDay;
}

class HourlyWeather {
  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  final DateTime time;
  final double temperature;
  final int weatherCode;
}

class DailyWeather {
  const DailyWeather({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherCode,
  });

  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final int weatherCode;
}

class WeatherData {
  const WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
    this.cityName,
  });

  final String? cityName;
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  factory WeatherData.fromJson(Map<String, dynamic> json, {String? cityName}) {
    final currentWeather = json['current_weather'] as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    final hourlyTimes = (hourly['time'] as List).cast<String>();
    final now = DateTime.parse(currentWeather['time'] as String);
    final currentIndex = hourlyTimes.indexOf(currentWeather['time'] as String);

    int getInt(List<dynamic> values, int idx) =>
        idx >= 0 && idx < values.length ? (values[idx] as num).round() : 0;
    double getDouble(List<dynamic> values, int idx) =>
        idx >= 0 && idx < values.length ? (values[idx] as num).toDouble() : 0;

    final apparentTemps = (hourly['apparent_temperature'] as List).cast<dynamic>();
    final humidityValues = (hourly['relative_humidity_2m'] as List).cast<dynamic>();
    final rainProbValues =
        (hourly['precipitation_probability'] as List).cast<dynamic>();

    final hourlyTemps = (hourly['temperature_2m'] as List).cast<dynamic>();
    final hourlyCodes = (hourly['weathercode'] as List).cast<dynamic>();

    final current = CurrentWeather(
      time: now,
      temperature: (currentWeather['temperature'] as num).toDouble(),
      apparentTemperature: getDouble(apparentTemps, currentIndex),
      windSpeed: (currentWeather['windspeed'] as num).toDouble(),
      humidity: getInt(humidityValues, currentIndex),
      rainProbability: getInt(rainProbValues, currentIndex),
      weatherCode: (currentWeather['weathercode'] as num).toInt(),
      isDay: (currentWeather['is_day'] as num?)?.toInt() == 1,
    );

    final start = currentIndex < 0 ? 0 : currentIndex;
    final end = (start + 24).clamp(0, hourlyTimes.length);
    final hourlyItems = <HourlyWeather>[];
    for (var i = start; i < end; i++) {
      hourlyItems.add(
        HourlyWeather(
          time: DateTime.parse(hourlyTimes[i]),
          temperature: (hourlyTemps[i] as num).toDouble(),
          weatherCode: (hourlyCodes[i] as num).toInt(),
        ),
      );
    }

    final dailyDates = (daily['time'] as List).cast<String>();
    final dailyMin = (daily['temperature_2m_min'] as List).cast<dynamic>();
    final dailyMax = (daily['temperature_2m_max'] as List).cast<dynamic>();
    final dailyCodes = (daily['weathercode'] as List).cast<dynamic>();

    final dailyItems = <DailyWeather>[];
    for (var i = 0; i < dailyDates.length && i < 7; i++) {
      dailyItems.add(
        DailyWeather(
          date: DateTime.parse(dailyDates[i]),
          minTemp: (dailyMin[i] as num).toDouble(),
          maxTemp: (dailyMax[i] as num).toDouble(),
          weatherCode: (dailyCodes[i] as num).toInt(),
        ),
      );
    }

    return WeatherData(
      cityName: cityName,
      current: current,
      hourly: hourlyItems,
      daily: dailyItems,
    );
  }
}
