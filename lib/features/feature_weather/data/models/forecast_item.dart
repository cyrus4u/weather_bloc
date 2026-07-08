import 'package:weather_bloc/features/feature_weather/domain/entities/forecast_days_entity.dart';

class ForecastItemModel extends ForecastItemEntity {
  const ForecastItemModel({
    required DateTime super.dt,
    required double super.temp,
    required double super.tempMin,
    required double super.tempMax,
    required String super.main,
    required String super.description,
    required String super.icon,
  });

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) {
    final mainData = json['main'] ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty ? weatherList[0] : {};

    return ForecastItemModel(
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