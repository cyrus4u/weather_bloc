import 'package:weather_bloc/features/feature_weather/domain/entities/current_city_entity.dart';

class CurrentCityModel extends CurrentCityEntity {
  CurrentCityModel({
    super.coord,
    super.weather,
    super.base,
    super.main,
    super.visibility,
    super.wind,
    super.clouds,
    super.dt,
    super.sys,
    super.timezone,
    super.id,
    super.name,
    super.cod,
  });

  factory CurrentCityModel.fromJson(dynamic json) {
    List<WeatherModel> weather = [];
    if (json['weather'] != null) {
      json['weather'].forEach((v) {
        weather.add(WeatherModel.fromJson(v));
      });
    }

    return CurrentCityModel(
      coord: json['coord'] != null ? CoordModel.fromJson(json['coord']) : null,
      weather: weather,
      base: json['base'],
      main: json['main'] != null ? MainModel.fromJson(json['main']) : null,
      visibility: json['visibility'],
      wind: json['wind'] != null ? WindModel.fromJson(json['wind']) : null,
      clouds: json['clouds'] != null
          ? CloudsModel.fromJson(json['clouds'])
          : null,
      dt: json['dt'],
      sys: json['sys'] != null ? SysModel.fromJson(json['sys']) : null,
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }
}

class SysModel extends Sys {
  const SysModel({
    super.type,
    super.id,
    super.country,
    super.sunrise,
    super.sunset,
  });

  factory SysModel.fromJson(Map<String, dynamic> json) {
    return SysModel(
      type: json["type"] is int ? json["type"] : null,
      id: json["id"] is int ? json["id"] : null,
      country: json["country"] is String ? json["country"] : null,
      sunrise: json["sunrise"] is int ? json["sunrise"] : null,
      sunset: json["sunset"] is int ? json["sunset"] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "country": country,
    "sunrise": sunrise,
    "sunset": sunset,
  };
}

class CloudsModel extends Clouds {
  const CloudsModel({super.all});

  factory CloudsModel.fromJson(Map<String, dynamic> json) {
    return CloudsModel(all: json["all"] is int ? json["all"] : null);
  }

  Map<String, dynamic> toJson() => {"all": all};
}

class WindModel extends Wind {
  const WindModel({super.speed, super.deg});

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      speed: json["speed"] is double ? json["speed"] : null,
      deg: json["deg"] is int ? json["deg"] : null,
    );
  }

  Map<String, dynamic> toJson() => {"speed": speed, "deg": deg};
}

class MainModel extends Main {
  const MainModel({
    super.temp,
    super.feelsLike,
    super.tempMin,
    super.tempMax,
    super.pressure,
    super.humidity,
    super.seaLevel,
    super.grndLevel,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      temp: json["temp"] is double ? json["temp"] : null,
      feelsLike: json["feels_like"] is double ? json["feels_like"] : null,
      tempMin: json["temp_min"] is double ? json["temp_min"] : null,
      tempMax: json["temp_max"] is double ? json["temp_max"] : null,
      pressure: json["pressure"] is int ? json["pressure"] : null,
      humidity: json["humidity"] is int ? json["humidity"] : null,
      seaLevel: json["sea_level"] is int ? json["sea_level"] : null,
      grndLevel: json["grnd_level"] is int ? json["grnd_level"] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "temp": temp,
    "feels_like": feelsLike,
    "temp_min": tempMin,
    "temp_max": tempMax,
    "pressure": pressure,
    "humidity": humidity,
    "sea_level": seaLevel,
    "grnd_level": grndLevel,
  };
}

class WeatherModel extends Weather {
  const WeatherModel({super.id, super.main, super.description, super.icon});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      id: json["id"] is int ? json["id"] : null,
      main: json["main"] is String ? json["main"] : null,
      description: json["description"] is String ? json["description"] : null,
      icon: json["icon"] is String ? json["icon"] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "main": main,
    "description": description,
    "icon": icon,
  };
}

class CoordModel extends Coord {
  const CoordModel({super.lon, super.lat});

  factory CoordModel.fromJson(Map<String, dynamic> json) {
    return CoordModel(
      lon: json["lon"] is double ? json["lon"] : null,
      lat: json["lat"] is double ? json["lat"] : null,
    );
  }

  Map<String, dynamic> toJson() => {"lon": lon, "lat": lat};
}
