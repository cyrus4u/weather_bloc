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

  // Returns a new HomeCompleted object, optionally overriding city and/or forecast,
  // while keeping any field that wasn't passed in unchanged.
  HomeCompleted copyWith({
    CurrentCityEntity? city, // new city value (optional, nullable)
    ForecastDaysEntity? forecast, // new forecast value (optional, nullable)
  }) {
    return HomeCompleted(
      // if `city` param was provided (not null), use it;
      // otherwise fall back to the existing value on this object
      city: city ?? this.city,

      // same logic: use new forecast if given, else keep the old one
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
