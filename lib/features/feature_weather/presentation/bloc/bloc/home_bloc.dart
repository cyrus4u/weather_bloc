import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_bloc/core/resources/data_state.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/cw_status.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUsecase getCurrentWeatherUsecase;
  HomeBloc(this.getCurrentWeatherUsecase)
    : super(HomeState(cwStatus: CwLoading())) {
    on<LoadCwEvent>((event, emit) async {
      print('Event received');
      emit(state.copyWith(newCwStatus: CwLoading()));
      DataState dataState = await getCurrentWeatherUsecase(event.cityName);
      print(dataState.runtimeType);
      if (dataState is DataSuccess) {
        print('SUCCESS');
        emit(state.copyWith(newCwStatus: CwComleted(dataState.data)));
      }
      if (dataState is DataFailed) {
        print('FAILED');
        print(dataState.error);
        emit(state.copyWith(newCwStatus: CwError(dataState.error!)));
      }
    });
  }
}
