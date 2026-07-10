import 'package:weather_bloc/core/usecase/use_case.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/suggest_city_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/repository/weather_repository.dart';

class GetSuggestionCityUsecase extends UseCase<List<DataEntity>, String> {
  final WeatherRepository _weatherRepository;
  GetSuggestionCityUsecase(this._weatherRepository);

  @override
  Future<List<DataEntity>> call(String param) {
    return _weatherRepository.fetchSuggestData(param);
  }
}
