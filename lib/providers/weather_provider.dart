import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Meteo_model.dart';
import '../services/weather_service.dart';

final weatherProvider = FutureProvider.family<MeteoModel, Map<String, dynamic>>(
  (ref, params) async {
    final service = WeatherService();
    return await service.fetchWeather(
      params['lat'],
      params['lon'],
      params['city'],
    );
  },
);
