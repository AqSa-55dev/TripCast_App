// Controller for Route Weather Screen (Screen 13)
// Follows ChooseLocationController & Nimbus GetX pattern (simple & clean)
// Location: lib/controller/weather_controller.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../model/city_search_model.dart';
import '../model/weather_model.dart';
import '../services/api_services/api_endpoints.dart';
import '../services/api_services/api_services.dart';
import '../utils/mapbox_config.dart';

class WeatherController extends GetxController {
  RxBool isLoading = false.obs;

  // Direct WeatherModel list (same pattern as listOfSearchCities)
  RxList<WeatherModel> listOfStopsWeather = <WeatherModel>[].obs;

  // Dynamic route stops info (city name + estimated arrival time)
  RxList<Map<String, String>> dynamicRouteStops = <Map<String, String>>[].obs;

  WeatherModel responseModel = WeatherModel();

  // Fetch live weather for dynamic route stops (Origin + intermediate weatherPoints + Destination)
  Future<void> getRouteWeather({
    required Result startingLocation,
    required Result destination,
    required DateTime departureDateTime,
    required String duration,
    required List<Position> weatherPoints,
  }) async {
    try {
      isLoading.value = true;
      listOfStopsWeather.clear();
      dynamicRouteStops.clear();

      // 1. Build complete coordinates list: Start -> Intermediate points -> End
      final List<Map<String, dynamic>> allPoints = [];

      allPoints.add({
        "name": startingLocation.name ?? "Origin",
        "lat": startingLocation.latitude ?? 31.5497,
        "lng": startingLocation.longitude ?? 74.3436,
      });

      for (int i = 0; i < weatherPoints.length; i++) {
        allPoints.add({
          "name": "", // Will be resolved via reverse geocoding
          "lat": weatherPoints[i].lat.toDouble(),
          "lng": weatherPoints[i].lng.toDouble(),
        });
      }

      allPoints.add({
        "name": destination.name ?? "Destination",
        "lat": destination.latitude ?? 33.6844,
        "lng": destination.longitude ?? 73.0479,
      });

      // 2. Calculate total duration in minutes to estimate arrival time at each stop
      final int totalMinutes = _parseDurationMinutes(duration);
      final int totalStops = allPoints.length;

      // 3. Fetch weather & city name for each stop
      for (int i = 0; i < totalStops; i++) {
        final point = allPoints[i];
        final double lat = point['lat'];
        final double lng = point['lng'];

        // Calculate estimated arrival time
        final int offsetMinutes = totalStops > 1
            ? (totalMinutes * i / (totalStops - 1)).round()
            : 0;
        final DateTime arrivalDt =
            departureDateTime.add(Duration(minutes: offsetMinutes));
        final String arrivalTime = DateFormat('h:mm a').format(arrivalDt);

        // Resolve city name for intermediate points
        String cityName = point['name'];
        if (cityName.isEmpty) {
          cityName = await _getCityName(lat, lng, fallback: "Stop ${i + 1}");
        }

        // Fetch weather from Open-Meteo API
        var responseFromApi = await ApiServices().getMethod(
          ApiEndpoints.getWeatherForecastUrl(
            latitude: lat,
            longitude: lng,
          ),
        );

        responseModel = WeatherModel.fromJson(
          jsonDecode(responseFromApi),
        );

        dynamicRouteStops.add({
          "city": cityName,
          "time": arrivalTime,
        });
        listOfStopsWeather.add(responseModel);
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  // Helper: Reverse geocode coordinates to get city/town name
  Future<String> _getCityName(
    double lat,
    double lng, {
    required String fallback,
  }) async {
    try {
      final res = await ApiServices().getMethod(
        ApiEndpoints.reverseGeocodeUrl(
          latitude: lat,
          longitude: lng,
          accessToken: MapboxConfig.accessToken,
        ),
      );
      final data = jsonDecode(res);
      final features = data['features'] as List?;
      if (features != null && features.isNotEmpty) {
        return features.first['text'] ?? fallback;
      }
    } catch (_) {}
    return fallback;
  }

  // Helper: Parse duration string like "4h 45m" into total minutes
  int _parseDurationMinutes(String duration) {
    int totalMinutes = 0;
    final hMatch = RegExp(r'(\d+)\s*h').firstMatch(duration);
    final mMatch = RegExp(r'(\d+)\s*m').firstMatch(duration);
    if (hMatch != null) totalMinutes += int.parse(hMatch.group(1)!) * 60;
    if (mMatch != null) totalMinutes += int.parse(mMatch.group(1)!);
    return totalMinutes > 0 ? totalMinutes : 60;
  }
}
