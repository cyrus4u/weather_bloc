import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_bloc/core/resources/data_state.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUsecase _getCurrentWeatherUsecase;
  final GetForecastWeatherUseCase _getForecastWeatherUseCase;

  HomeBloc(this._getCurrentWeatherUsecase, this._getForecastWeatherUseCase)
    : super(HomeLoading()) {
    on<LoadCwEvent>((event, emit) async {
      if (state is! HomeCompleted) emit(HomeLoading());
      final dataState = await _getCurrentWeatherUsecase(event.cityName);
      if (dataState is DataSuccess) {
        final current = state is HomeCompleted
            ? state as HomeCompleted
            : const HomeCompleted();
        emit(current.copyWith(city: dataState.data));
      } else if (dataState is DataFailed) {
        emit(HomeError(dataState.error ?? "Unknown error"));
      }
    });

    on<LoadFwEvent>((event, emit) async {
      if (state is! HomeCompleted) emit(HomeLoading());
      final dataState = await _getForecastWeatherUseCase(event.cityName);
      if (dataState is DataSuccess) {
        final current = state is HomeCompleted
            ? state as HomeCompleted
            : const HomeCompleted();
        emit(current.copyWith(forecast: dataState.data));
      } else if (dataState is DataFailed) {
        emit(HomeError(dataState.error ?? "Unknown error"));
      }
    });
  }
}
