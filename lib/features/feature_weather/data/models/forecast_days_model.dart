import 'package:weather_bloc/features/feature_weather/data/models/forecast_item.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/forecast_days_entity.dart';


 

class ForecastDaysModel extends ForecastDaysEntity {
  const ForecastDaysModel({
    required double lat,
    required double lon,
    required int timezoneOffset,
    required List<ForecastItem> list,
  }) : super(
          lat: lat,
          lon: lon,
          timezoneOffset: timezoneOffset,
          list: list,
        );

  factory ForecastDaysModel.fromJson(Map<String, dynamic> json) {
    final city = json['city'] ?? {};
    final coord = city['coord'] ?? {};

    final lat = (coord['lat'] as num?)?.toDouble() ?? 0.0;
    final lon = (coord['lon'] as num?)?.toDouble() ?? 0.0;
    final timezoneOffset = city['timezone'] ?? 0;

    final List<ForecastItem> items = [];
    if (json['list'] != null) {
      for (var v in json['list']) {
        items.add(ForecastItem.fromJson(v));
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