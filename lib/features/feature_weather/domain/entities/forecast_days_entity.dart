import 'package:equatable/equatable.dart';

class ForecastDaysEntity extends Equatable {
  final double? lat;
  final double? lon;
  final int? timezoneOffset;
  final List<ForecastItemEntity>? list;

  const ForecastDaysEntity({
    this.lat,
    this.lon,
    this.timezoneOffset,
    this.list,
  });

  @override
  List<Object?> get props => [lat, lon, timezoneOffset, list];

  @override
  bool? get stringify => true;
}

class ForecastItemEntity extends Equatable {
  final DateTime? dt;
  final double? temp;
  final double? tempMin;
  final double? tempMax;
  final String? main;
  final String? description;
  final String? icon;

  const ForecastItemEntity({
    this.dt,
    this.temp,
    this.tempMin,
    this.tempMax,
    this.main,
    this.description,
    this.icon,
  });

  @override
  List<Object?> get props => [dt, temp, tempMin, tempMax, main, description, icon];

  @override
  bool? get stringify => true;
}