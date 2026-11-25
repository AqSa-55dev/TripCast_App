

import 'dart:convert';
import 'package:get/get.dart';
import '../model/weather_model.dart';
import '../services/api_services/api_endpoints.dart';
import '../services/api_services/api_services.dart';

class WeatherController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<WeatherModel> listOfStopsWeather = <WeatherModel>[].obs;

  WeatherModel responseModel = WeatherModel();

  // Route stops (Name, Coordinates, Estimated Arrival Time)
  final List<Map<String, dynamic>> routeStops = [
    {"city": "Lahore", "lat": 31.5497, "lng": 74.3436, "time": "8:00 AM"},
    {"city": "Gujranwala", "lat": 32.1877, "lng": 74.1945, "time": "9:15 AM"},
    {"city": "Gujrat", "lat": 32.5742, "lng": 74.0754, "time": "10:30 AM"},
    {"city": "Jhelum", "lat": 32.9405, "lng": 73.7276, "time": "11:45 AM"},
    {"city": "Islamabad", "lat": 33.6844, "lng": 73.0479, "time": "12:45 PM"},
  ];

  @override
  void onInit() {
    super.onInit();
    getRouteWeather();
  }

  Future<void> getRouteWeather() async {
    try {
      isLoading.value = true;
      listOfStopsWeather.clear();

      for (var stop in routeStops) {
        var responseFromApi = await ApiServices().getMethod(
          ApiEndpoints.getWeatherForecastUrl(
            latitude: stop['lat'],
            longitude: stop['lng'],
          ),
        );

        responseModel = WeatherModel.fromJson(
          jsonDecode(responseFromApi),
        );

        listOfStopsWeather.add(responseModel);
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
}
