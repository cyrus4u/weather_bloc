import 'package:flutter/material.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/current_city_entity.dart';

@immutable
abstract class CwStatus {}

class CwLoading extends CwStatus {}

class CwComleted extends CwStatus {
  final CurrentCityEntity currentCityEntity;
  CwComleted(this.currentCityEntity);
}

class CwError extends CwStatus {
  final String message;
  CwError(this.message);
}
