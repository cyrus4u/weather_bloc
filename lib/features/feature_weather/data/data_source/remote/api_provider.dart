import 'package:dio/dio.dart';
import 'package:weather_bloc/core/params/forecast_params.dart';
import 'package:weather_bloc/core/utils/constants.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String apiKey = Constants.apiKey1;

  /// Get city coordinates (lat/lon) by city name
  Future<List<dynamic>> getCityCoordinates(String cityName) async {
    try {
      final response = await _dio.get(
        '${Constants.baseUrl}/geo/1.0/direct',
        queryParameters: {'q': cityName, 'appid': apiKey},
      );

      // The API returns a list of results
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get current weather by lat/lon
  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '${Constants.baseUrl}/data/2.5/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
        },
      );
      print(response.data);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
   /// 5 days forecast api
  Future<dynamic> sendRequest5DaysForcast(double lat, double lon) async {

    var response = await _dio.get(
        "${Constants.baseUrl}/data/2.5/forecast",
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
          'cnt': 6
        });

    return response.data as Map<String, dynamic>; // <-- return the JSON map
  }

  /// city name suggest api
  Future<dynamic> sendRequestCitySuggestion(String prefix) async {
    var response = await _dio.get(
        "http://geodb-free-service.wirefreethought.com/v1/geo/cities",
        queryParameters: {'limit': 7, 'offset': 0, 'namePrefix': prefix});

    return response;
  }
}
