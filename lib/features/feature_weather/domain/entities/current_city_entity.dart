import 'package:equatable/equatable.dart';

class CurrentCityEntity extends Equatable {
  final Coord? coord;
  final List<Weather>? weather;
  final String? base;
  final Main? main;
  final int? visibility;
  final Wind? wind;
  final Clouds? clouds;
  final int? dt;
  final Sys? sys;
  final int? timezone;
  final int? id;
  final String? name;
  final int? cod;

  const CurrentCityEntity({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  @override
  List<Object?> get props => [
    coord,
    weather,
    base,
    main,
    visibility,
    wind,
    clouds,
    dt,
    sys,
    timezone,
    id,
    name,
    cod,
  ];
}

class Coord extends Equatable {
  final double? lon;
  final double? lat;

  const Coord({this.lon, this.lat});

  @override
  List<Object?> get props => [lon, lat];
}

class Weather extends Equatable {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  const Weather({this.id, this.main, this.description, this.icon});

  @override
  List<Object?> get props => [id, main, description, icon];
}

class Main extends Equatable {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;

  const Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  @override
  List<Object?> get props => [
    temp,
    feelsLike,
    tempMin,
    tempMax,
    pressure,
    humidity,
    seaLevel,
    grndLevel,
  ];
}

class Wind extends Equatable {
  final double? speed;
  final int? deg;

  const Wind({this.speed, this.deg});

  @override
  List<Object?> get props => [speed, deg];
}

class Clouds extends Equatable {
  final int? all;

  const Clouds({this.all});

  @override
  List<Object?> get props => [all];
}

class Sys extends Equatable {
  final int? type;
  final int? id;
  final String? country;
  final int? sunrise;
  final int? sunset;

  const Sys({this.type, this.id, this.country, this.sunrise, this.sunset});

  @override
  List<Object?> get props => [type, id, country, sunrise, sunset];
}