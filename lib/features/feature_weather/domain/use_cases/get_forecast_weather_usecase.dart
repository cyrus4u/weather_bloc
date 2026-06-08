import 'package:weather_bloc/core/resources/data_state.dart';
import 'package:weather_bloc/core/usecase/use_case.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/repository/weather_repository.dart';

class GetForecastWeatherUseCase
    implements UseCase<DataState<ForecastDaysEntity>, String> {
  final WeatherRepository _weatherRepository;
  GetForecastWeatherUseCase(this._weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call(String params) {
    return _weatherRepository.fetchForecastWeatherData(params);
  }
}
