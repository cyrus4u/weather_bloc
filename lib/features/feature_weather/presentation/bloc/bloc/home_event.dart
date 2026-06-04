part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}
final class LoadCwEvent extends HomeEvent {
  final String cityName;

  const LoadCwEvent(this.cityName);

  @override
  List<Object?> get props => [cityName];
}