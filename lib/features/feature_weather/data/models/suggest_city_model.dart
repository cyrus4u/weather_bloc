import 'package:weather_bloc/features/feature_weather/domain/entities/suggest_city_entity.dart';

/// data : [{"id":58764,"wikiDataId":"Q605157","type":"CITY","city":"Babol","name":"Babol","country":"Iran","countryCode":"IR","region":"Mazandaran","regionCode":"21","latitude":36.55,"longitude":52.683333333,"population":250217}]
/// metadata : {"currentOffset":0,"totalCount":1}

class SuggestCityModel extends SuggestCityEntity {
  const SuggestCityModel({super.data, super.metadata});

  factory SuggestCityModel.fromJson(dynamic json) {
    List<DataModel> data = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(DataModel.fromJson(v));
      });
    }

    return SuggestCityModel(
      data: data,
      metadata: json['metadata'] != null
          ? MetadataModel.fromJson(json['metadata'])
          : null,
    );
  }
}

/// currentOffset : 0
/// totalCount : 1

class MetadataModel extends MetadataEntity {
  const MetadataModel({super.currentOffset, super.totalCount});

  factory MetadataModel.fromJson(dynamic json) {
    return MetadataModel(
      currentOffset: json['currentOffset'],
      totalCount: json['totalCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentOffset': currentOffset,
      'totalCount': totalCount,
    };
  }
}

/// id : 58764
/// wikiDataId : "Q605157"
/// type : "CITY"
/// city : "Babol"
/// name : "Babol"
/// country : "Iran"
/// countryCode : "IR"
/// region : "Mazandaran"
/// regionCode : "21"
/// latitude : 36.55
/// longitude : 52.683333333
/// population : 250217

class DataModel extends DataEntity {
  const DataModel({
    super.id,
    super.wikiDataId,
    super.type,
    super.city,
    super.name,
    super.country,
    super.countryCode,
    super.region,
    super.regionCode,
    super.latitude,
    super.longitude,
    super.population,
  });

  factory DataModel.fromJson(dynamic json) {
    return DataModel(
      id: json['id'],
      wikiDataId: json['wikiDataId'],
      type: json['type'],
      city: json['city'],
      name: json['name'],
      country: json['country'],
      countryCode: json['countryCode'],
      region: json['region'],
      regionCode: json['regionCode'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      population: json['population'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wikiDataId': wikiDataId,
      'type': type,
      'city': city,
      'name': name,
      'country': country,
      'countryCode': countryCode,
      'region': region,
      'regionCode': regionCode,
      'latitude': latitude,
      'longitude': longitude,
      'population': population,
    };
  }
}