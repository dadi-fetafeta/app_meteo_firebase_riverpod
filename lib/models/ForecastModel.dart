class ForecastModel {
  final List<String> dates;
  final List<double> temps;

  ForecastModel({required this.dates, required this.temps});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dates: List<String>.from(json['daily']['time']),
      temps: List<double>.from(json['daily']['temperature_2m_max']),
    );
  }
}
