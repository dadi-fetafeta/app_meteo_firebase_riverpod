import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Meteo_model.dart';

class WeatherService {
  Future<MeteoModel> fetchWeather(double lat, double lon, String city) async {
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MeteoModel.fromJson(data, city);
    } else {
      throw Exception("Erreur météo");
    }
  }
}
