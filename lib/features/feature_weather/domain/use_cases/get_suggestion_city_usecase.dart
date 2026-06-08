import 'package:weather_bloc/core/usecase/use_case.dart';
import 'package:weather_bloc/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather_bloc/features/feature_weather/domain/repository/weather_repository.dart';

class GetSuggestionCityUsecase extends UseCase<List<Data>, String> {
  final WeatherRepository _weatherRepository;
  GetSuggestionCityUsecase(this._weatherRepository);

  @override
  Future<List<Data>> call(String param) {
    return _weatherRepository.fetchSuggestData(param);
  }
}
