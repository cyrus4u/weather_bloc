part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// for current weather
final class LoadCwEvent extends HomeEvent {
  final String cityName;
  const LoadCwEvent(this.cityName);
  @override
  List<Object?> get props => [cityName];
}

///for 5 days forecast
final class LoadFwEvent extends HomeEvent {
  final String cityName;
  const LoadFwEvent(this.cityName);
  @override
  List<Object?> get props => [cityName];
}
