import 'package:get_it/get_it.dart';
import 'package:weather_bloc/features/feature_bookmark/data/data_source/local/database.dart';
import 'package:weather_bloc/features/feature_bookmark/data/repository/city_repositoryImpl.dart';
import 'package:weather_bloc/features/feature_bookmark/domain/repository/city_repository.dart';
import 'package:weather_bloc/features/feature_bookmark/domain/use_cases/delete_city_usecase.dart';
import 'package:weather_bloc/features/feature_bookmark/domain/use_cases/get_all_city_usecase.dart';
import 'package:weather_bloc/features/feature_bookmark/domain/use_cases/get_city_usecase.dart';
import 'package:weather_bloc/features/feature_bookmark/domain/use_cases/save_city_usecase.dart';
import 'package:weather_bloc/features/feature_bookmark/presentation/bloc/bloc/bookmark_bloc.dart';
import 'package:weather_bloc/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather_bloc/features/feature_weather/data/repository/weather_repositoryImpl.dart';
import 'package:weather_bloc/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_suggestion_city_usecase.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/home_bloc.dart';

GetIt locator = GetIt.instance;

setup() async {
  locator.registerSingleton<ApiProvider>(ApiProvider());

  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  locator.registerSingleton<AppDatabase>(database);

  /// repositories
  locator.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(locator()),
  );
  locator.registerSingleton<CityRepository>(
    CityRepositoryImpl(database.cityDao),
  );

  /// use case
  locator.registerSingleton<GetCurrentWeatherUsecase>(
    GetCurrentWeatherUsecase(locator()),
  );
  locator.registerSingleton<GetForecastWeatherUseCase>(
    GetForecastWeatherUseCase(locator()),
  );
  locator.registerSingleton<GetSuggestionCityUsecase>(
    GetSuggestionCityUsecase(locator()),
  );
  locator.registerSingleton<GetCityUseCase>(GetCityUseCase(locator()));
  locator.registerSingleton<SaveCityUseCase>(SaveCityUseCase(locator()));
  locator.registerSingleton<GetAllCityUseCase>(GetAllCityUseCase(locator()));
  locator.registerSingleton<DeleteCityUseCase>(DeleteCityUseCase(locator()));

  /// BLOC
  locator.registerSingleton<HomeBloc>(
    HomeBloc(
      getCurrentWeatherUsecase: locator(),
      getForecastWeatherUseCase: locator(),
    ),
  );
  locator.registerSingleton<BookmarkBloc>(
    BookmarkBloc(
      getCityUseCase: locator(),
      saveCityUseCase: locator(),
      getAllCityUseCase: locator(),
      deleteCityUseCase: locator(),
    ),
  );
}
