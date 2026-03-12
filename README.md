# OpenMeteoFlutter

Aplicación de clima en Flutter enfocada en Android (APK) y compatible con Web, usando Open-Meteo + Riverpod.

## Estructura

```text
lib/
 ├── main.dart
 ├── core
 │   ├── constants
 │   └── utils
 ├── data
 │   ├── models
 │   ├── services
 │   └── repositories
 ├── features
 │   └── weather
 │       ├── screens
 │       ├── widgets
 │       └── providers
 └── theme
```

## Funcionalidades incluidas

- Clima actual por ubicación del usuario (geolocator + permission_handler)
- Búsqueda global de ciudades (Open-Meteo Geocoding)
- Pronóstico por horas (24h) y por días (7 días)
- Fondo dinámico y animaciones por condición climática
- Debounce de 300ms en buscador
- Historial de ciudades recientes
- Estados de carga/error y cache simple en repositorio

## APIs

- Forecast: `https://api.open-meteo.com/v1/forecast`
- Geocoding: `https://geocoding-api.open-meteo.com/v1/search`

## Dependencias

- http
- flutter_riverpod
- geolocator
- permission_handler
- intl
- lottie
- rive
- flutter_animate
- cached_network_image

## Ejecutar

```bash
flutter pub get
flutter run
```

## Generar APK

```bash
flutter build apk
```
