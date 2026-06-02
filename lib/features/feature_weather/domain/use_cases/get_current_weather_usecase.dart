import 'package:weather_bloc/core/resources/data_state.dart';
import 'package:weather_bloc/core/usecase/use_case.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/repository/weather_repository.dart';

class GetCurrentWeatherUsecase
    extends UseCase<DataState<CurrentCityEntity>, String> {
  final WeatherRepository weatherRepository;
  GetCurrentWeatherUsecase(this.weatherRepository);

  @override
  Future<DataState<CurrentCityEntity>> call(String param) {
    return weatherRepository.fetchCurrentWeatherData(param);
  }
}
