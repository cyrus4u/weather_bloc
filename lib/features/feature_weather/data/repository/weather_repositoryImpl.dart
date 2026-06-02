import 'package:weather_bloc/core/resources/data_state.dart';
import 'package:weather_bloc/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather_bloc/features/feature_weather/data/models/current_city_model.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/repository/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final ApiProvider apiProvider;

  WeatherRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(
      String cityName) async {
    try {
      final coordinates =
          await apiProvider.getCityCoordinates(cityName);

      if (coordinates.isEmpty) {
        return const DataFailed("City not found");
      }

      final double lat = coordinates[0]['lat'];
      final double lon = coordinates[0]['lon'];

      final weatherData =
          await apiProvider.getCurrentWeather(lat, lon);

      final currentCityEntity =
          CurrentCityModel.fromJson(weatherData);

      return DataSuccess(currentCityEntity);
    } catch (e) {
      return const DataFailed(
        "Please check your connection...",
      );
    }
  }
}