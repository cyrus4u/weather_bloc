import 'package:equatable/equatable.dart';

class SuggestCityEntity extends Equatable {
  final List<DataEntity>? data;
  final MetadataEntity? metadata;

  const SuggestCityEntity({this.data, this.metadata});

  @override
  List<Object?> get props => [data, metadata];

  @override
  bool? get stringify => true;
}

class DataEntity extends Equatable {
  final int? id;
  final String? wikiDataId;
  final String? type;
  final String? city;
  final String? name;
  final String? country;
  final String? countryCode;
  final String? region;
  final String? regionCode;
  final double? latitude;
  final double? longitude;
  final int? population;

  const DataEntity({
    this.id,
    this.wikiDataId,
    this.type,
    this.city,
    this.name,
    this.country,
    this.countryCode,
    this.region,
    this.regionCode,
    this.latitude,
    this.longitude,
    this.population,
  });

  @override
  List<Object?> get props => [
    id,
    wikiDataId,
    type,
    city,
    name,
    country,
    countryCode,
    region,
    regionCode,
    latitude,
    longitude,
    population,
  ];

  @override
  bool? get stringify => true;
}

class MetadataEntity extends Equatable {
  final int? currentOffset;
  final int? totalCount;

  const MetadataEntity({this.currentOffset, this.totalCount});

  @override
  List<Object?> get props => [currentOffset, totalCount];

  @override
  bool? get stringify => true;
}