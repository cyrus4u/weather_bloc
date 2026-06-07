class ForecastItem {
  final DateTime dt;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String main;
  final String description;
  final String icon;

  ForecastItem({
    required this.dt,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    final mainData = json['main'] ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty ? weatherList[0] : {};

    return ForecastItem(
      dt: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temp: (mainData['temp'] as num?)?.toDouble() ?? 0.0,
      tempMin: (mainData['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (mainData['temp_max'] as num?)?.toDouble() ?? 0.0,
      main: weather['main'] ?? '',
      description: weather['description'] ?? '',
      icon: weather['icon'] ?? '',
    );
  }
}