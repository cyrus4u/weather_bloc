import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_bloc/core/resources/data_state.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';



class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUsecase getCurrentWeatherUsecase;

  HomeBloc(this.getCurrentWeatherUsecase) : super(HomeLoading()) {
    on<LoadCwEvent>((event, emit) async {
      print('Event received');
      emit(HomeLoading());

      try {
        DataState dataState = await getCurrentWeatherUsecase(event.cityName);
        print(dataState.runtimeType);

        if (dataState is DataSuccess) {
          print('SUCCESS');
          emit(HomeCompleted(dataState.data!));
        } else if (dataState is DataFailed) {
          print('FAILED');
          print(dataState.error);
          emit(HomeError(dataState.error ?? "Unknown error"));
        }
      } catch (e) {
        print('BLoC exception: $e');
        emit(HomeError("Unexpected error: $e"));
      }
    });
  }
}
