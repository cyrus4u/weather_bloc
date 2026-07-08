import 'package:weather_bloc/core/resources/data_state.dart';
import 'package:weather_bloc/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather_bloc/features/feature_weather/data/models/coordinates.dart';
import 'package:weather_bloc/features/feature_weather/data/models/current_city_model.dart';
import 'package:weather_bloc/features/feature_weather/data/models/forecast_days_model.dart';
import 'package:weather_bloc/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/suggest_city_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/repository/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final ApiProvider apiProvider;

  WeatherRepositoryImpl(this.apiProvider);

  Future<Coordinates?> _getCoordinates(String cityName) async {
    try {
      // Call  API provider to get city coordinates
      final coordinatesList = await apiProvider.getCityCoordinates(cityName);

      // If API returned nothing, return null
      if (coordinatesList.isEmpty) return null;

      // Extract lat/lon safely and convert to double
      final lat = (coordinatesList[0]['lat'] as num).toDouble();
      final lon = (coordinatesList[0]['lon'] as num).toDouble();

      return Coordinates(lat: lat, lon: lon);
    } catch (e, st) {
      // Optional: log error for debugging
      print('Error fetching coordinates: $e\n$st');
      return null;
    }
  }

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(
    String cityName,
  ) async {
    try {
      final coords = await _getCoordinates(cityName);
      if (coords == null) return const DataFailed("City not found");

      final weatherData = await apiProvider.getCurrentWeather(
        coords.lat,
        coords.lon,
      );

      final currentCityEntity = CurrentCityModel.fromJson(weatherData);
      return DataSuccess(currentCityEntity);
    } catch (e, st) {
      print('Error fetching current weather: $e\n$st');
      return const DataFailed("Please check your connection...");
    }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(
    String cityName,
  ) async {
    try {
      final coords = await _getCoordinates(cityName);
      if (coords == null) return const DataFailed("City not found");

      final weatherData = await apiProvider.sendRequest5DaysForcast(
        coords.lat,
        coords.lon,
      );
      print(weatherData);

      final forecastEntity = ForecastDaysModel.fromJson(weatherData);
      print('Forecast entity: $forecastEntity');
      return DataSuccess(forecastEntity);
    } catch (e, st) {
      print('================================');
      print('Forecast Exception');
      print(e);
      print(st);
      print('================================');

      return DataFailed(e.toString());
    }
    // catch (e, st) {
    //   print('Error fetching forecast: $e\n$st');
    //   return const DataFailed("Please check your connection...");
    // }
  }

  @override
  Future<List<DataEntity>> fetchSuggestData(cityName) async{
    final response = await apiProvider.sendRequestCitySuggestion(cityName);

    SuggestCityEntity suggestCityEntity = SuggestCityModel.fromJson(response.data);

    return suggestCityEntity.data!;
  }
}
