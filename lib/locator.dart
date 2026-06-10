import 'package:get_it/get_it.dart';
import 'package:weather_bloc/features/feature_bookmark/data/data_source/local/database.dart';
import 'package:weather_bloc/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather_bloc/features/feature_weather/data/repository/weather_repositoryImpl.dart';
import 'package:weather_bloc/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/home_bloc.dart';

GetIt locator = GetIt.instance;

setup() async {
  // 1. Register objects in setup
  locator.registerSingleton<ApiProvider>(ApiProvider());

  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  locator.registerSingleton<AppDatabase>(database);

  locator.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(locator()), // injects ApiProvider
  );

  locator.registerSingleton<GetCurrentWeatherUsecase>(
    GetCurrentWeatherUsecase(locator()), // injects WeatherRepository
  );

  locator.registerSingleton<GetForecastWeatherUseCase>(
    GetForecastWeatherUseCase(locator()), // injects WeatherRepository
  );

  locator.registerSingleton<HomeBloc>(
    HomeBloc(locator(), locator()), // injects both use cases
  );
}
