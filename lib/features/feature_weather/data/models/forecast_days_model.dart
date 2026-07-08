import 'package:weather_bloc/features/feature_weather/data/models/forecast_item.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/forecast_days_entity.dart';

class ForecastDaysModel extends ForecastDaysEntity {
  const ForecastDaysModel({
    required super.lat,
    required super.lon,
    required super.timezoneOffset,
    required super.list,
  });

  factory ForecastDaysModel.fromJson(Map<String, dynamic> json) {
    final city = json['city'] ?? {};
    final coord = city['coord'] ?? {};

    final lat = (coord['lat'] as num?)?.toDouble() ?? 0.0;
    final lon = (coord['lon'] as num?)?.toDouble() ?? 0.0;
    final timezoneOffset = city['timezone'] ?? 0;

    final List<ForecastItemModel> items = [];
    if (json['list'] != null) {
      for (var v in json['list']) {
        items.add(ForecastItemModel.fromJson(v));
      }
    }

    return ForecastDaysModel(
      lat: lat,
      lon: lon,
      timezoneOffset: timezoneOffset,
      list: items,
    );
  }
}