import 'package:flutter/material.dart';
import 'package:weather_bloc/core/widgets/main_wrapper.dart';
import 'package:weather_bloc/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather_bloc/features/feature_weather/data/repository/weather_repositoryimpl.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GetCurrentWeatherUsecase getCurrentWeatherUsecase =
        GetCurrentWeatherUsecase(WeatherRepositoryImpl(ApiProvider()));
    getCurrentWeatherUsecase('Tehran');
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainWrapper());
  }
}
