import 'package:weather_bloc/core/resources/data_state.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/suggest_city_entity.dart';

abstract class WeatherRepository {
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(
    String cityName,
  );
  Future<List<DataEntity>> fetchSuggestData(cityName);
}
