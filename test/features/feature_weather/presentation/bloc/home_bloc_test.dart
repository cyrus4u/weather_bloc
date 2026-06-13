import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_bloc/core/resources/data_state.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/home_bloc.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentWeatherUsecase, GetForecastWeatherUseCase])
void main() {
  MockGetCurrentWeatherUsecase mockGetCurrentWeatherUsecase =
      MockGetCurrentWeatherUsecase();
  MockGetForecastWeatherUseCase mockGetForecastWeatherUseCase =
      MockGetForecastWeatherUseCase();

  String cityName = 'Tehran';
  String error = 'error';

  group('cw Event Test', () {
    when(
      mockGetCurrentWeatherUsecase.call(any),
    ).thenAnswer((_) async => Future.value(DataSuccess(CurrentCityEntity())));

    blocTest<HomeBloc, HomeState>(
      'emits loading and completed state',
      build: () {
        when(
          mockGetCurrentWeatherUsecase.call(any),
        ).thenAnswer((_) async => DataSuccess(CurrentCityEntity()));

        when(
          mockGetForecastWeatherUseCase.call(any),
        ).thenAnswer((_) async => DataSuccess(null));

        return HomeBloc(
          mockGetCurrentWeatherUsecase,
          mockGetForecastWeatherUseCase,
        );
      },
      act: (bloc) => bloc.add(LoadCwEvent(cityName)),
      expect: () => [isA<HomeLoading>(), isA<HomeCompleted>()],
    );

    /// Second Way
    test('emit Loading and Error state', () {
      when(
        mockGetCurrentWeatherUsecase.call(any),
      ).thenAnswer((_) async => DataFailed(error));

      final bloc = HomeBloc(
        mockGetCurrentWeatherUsecase,
        mockGetForecastWeatherUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeLoading>(),
          isA<HomeError>().having((s) => s.message, 'message', error),
        ]),
      );

      bloc.add(LoadCwEvent(cityName));
    });
  });
}
