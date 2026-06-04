part of 'home_bloc.dart';



sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeLoading extends HomeState {}

final class HomeCompleted extends HomeState {
  final CurrentCityEntity city;

  const HomeCompleted(this.city);

  @override
  List<Object?> get props => [city];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}