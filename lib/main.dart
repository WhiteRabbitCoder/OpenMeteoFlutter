import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_meteo_flutter/features/weather/screens/home_screen.dart';
import 'package:open_meteo_flutter/features/weather/screens/splash_screen.dart';
import 'package:open_meteo_flutter/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: OpenMeteoApp()));
}

class OpenMeteoApp extends StatelessWidget {
  const OpenMeteoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Meteo Flutter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(next: HomeScreen()),
    );
  }
}
