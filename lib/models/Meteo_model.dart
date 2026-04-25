class MeteoModel {
  final double temperature;
  final double windSpeed;
  final String city;

  MeteoModel({
    required this.temperature,
    required this.windSpeed,
    required this.city,
  });

  factory MeteoModel.fromJson(Map<String, dynamic> json, String city) {
    return MeteoModel(
      temperature: json['current_weather']['temperature'].toDouble(),
      windSpeed: json['current_weather']['windspeed'].toDouble(),
      city: city,
    );
  }
}
