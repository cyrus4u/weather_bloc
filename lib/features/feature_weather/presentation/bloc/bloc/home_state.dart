part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeLoading extends HomeState {}

final class HomeCompleted extends HomeState {
  final CurrentCityEntity? city;
  final ForecastDaysEntity? forecast;

  const HomeCompleted({this.city, this.forecast});

  HomeCompleted copyWith({
    CurrentCityEntity? city,
    ForecastDaysEntity? forecast,
  }) {
    return HomeCompleted(
      city: city ?? this.city,
      forecast: forecast ?? this.forecast,
    );
  }

  @override
  List<Object?> get props => [city, forecast];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

