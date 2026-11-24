

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/weather_model.dart';
import '../services/api_services/api_endpoints.dart';
import '../services/api_services/api_services.dart';
import '../utils/app_colors.dart';

class StopWeatherItem {
  final String cityName;
  final String condition;
  final String time;
  final String temperature;
  final String rain;
  final String humidity;
  final String wind;
  final IconData weatherIcon;
  final Color cardColor;
  final Color iconColor;

  StopWeatherItem({
    required this.cityName,
    required this.condition,
    required this.time,
    required this.temperature,
    required this.rain,
    required this.humidity,
    required this.wind,
    required this.weatherIcon,
    required this.cardColor,
    required this.iconColor,
  });
}

class WeatherController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  RxBool isLoading = false.obs;

  Rx<WeatherModel?> weatherData = Rx<WeatherModel?>(null);

  RxList<String> rainPercentages = <String>[].obs;
  RxList<String> hours = <String>[].obs;
  RxList<double> rainBarHeights = <double>[].obs;
  RxList<StopWeatherItem> weatherStops = <StopWeatherItem>[].obs;

  // Waypoints coordinates along Lahore to Islamabad route
  final List<Map<String, dynamic>> routeWaypoints = [
    {"city": "Lahore", "lat": 31.5497, "lng": 74.3436, "time": "8:00 AM"},
    {"city": "Gujranwala", "lat": 32.1877, "lng": 74.1945, "time": "9:15 AM"},
    {"city": "Gujrat", "lat": 32.5742, "lng": 74.0754, "time": "10:30 AM"},
    {"city": "Jhelum", "lat": 32.9405, "lng": 73.7276, "time": "11:45 AM"},
    {"city": "Islamabad", "lat": 33.6844, "lng": 73.0479, "time": "12:45 PM"},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchRouteWeather();
  }

  Future<void> fetchRouteWeather() async {
    try {
      isLoading.value = true;
      weatherStops.clear();

      for (int i = 0; i < routeWaypoints.length; i++) {
        final stop = routeWaypoints[i];
        final url = ApiEndpoints.getWeatherForecastUrl(
          latitude: stop['lat'],
          longitude: stop['lng'],
        );

        // API call using Nimbus ApiServices
        final response = await _apiServices.getMethod(url);
        final Map<String, dynamic> jsonResponse = jsonDecode(response);

        // Parse into WeatherModel
        final model = WeatherModel.fromJson(jsonResponse);

        // Set weatherData for the first stop (Lahore) for hourly charts
        if (i == 0) {
          weatherData.value = model;
          _populateHourlyRainChart(model);
        }

        // Map current stop to StopWeatherItem
        final stopItem = _buildStopItem(stop['city'], stop['time'], model, i);
        weatherStops.add(stopItem);
      }
    } catch (e) {
      debugPrint("Error fetching route weather: $e");
      Get.snackbar("Notice", "Unable to load live weather, displaying cached data");
      _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }

  // Populate hourly rain probability bars from WeatherModel.hourly
  void _populateHourlyRainChart(WeatherModel model) {
    rainPercentages.clear();
    hours.clear();
    rainBarHeights.clear();

    final defaultHours = ['8 AM', '9 AM', '10 AM', '11 AM', '12 PM', '1 PM'];
    final hourlyRain = model.hourly?.precipitationProbability ?? [];

    // 8 AM corresponds to index 8 in Open-Meteo 24-hour array (00:00 to 23:00)
    const int startHourIndex = 8;

    for (int i = 0; i < defaultHours.length; i++) {
      hours.add(defaultHours[i]);

      int rainVal = 0;
      int targetIndex = startHourIndex + i;
      if (targetIndex < hourlyRain.length) {
        rainVal = hourlyRain[targetIndex];
      }
      rainPercentages.add("$rainVal%");

      // Calculate bar height proportionally (max 65.h, min 6.h so the pill base is visible)
      double height = (rainVal * 0.65).clamp(6.0, 65.0);
      rainBarHeights.add(height);
    }
  }

  // Build individual StopWeatherItem with proper colors and icons
  StopWeatherItem _buildStopItem(
      String cityName, String time, WeatherModel model, int index) {
    final current = model.current;
    final int code = current?.weatherCode ?? 0;
    final String condition = _getConditionText(code);
    final IconData icon = _getWeatherIcon(code);

    // Weather condition
    Color cardColor;
    Color iconColor;

    if (code >= 51 && code <= 99) {
      // Rain / Thunderstorm: Soft Blue card
      cardColor = const Color(0xffE4EFFF);
      iconColor = AppColors.primary;
    } else if (index == 0) {
      // Lahore (Starting point)
      cardColor = const Color(0xffFFF8DF);
      iconColor = const Color(0xffE9A323);
    } else {
      // Other normal stops: Clean Pure White card with soft blue icon
      cardColor = AppColors.pureWhite;
      iconColor = const Color(0xff6387B4);
    }

    // Stop rain probability mapped to arrival hour
    final hourlyRain = model.hourly?.precipitationProbability ?? [];
    int arrivalHourIndex = 8 + index; // 8 AM for stop 0, 9 AM for stop 1, etc.
    int stopRain = 0;
    if (arrivalHourIndex < hourlyRain.length) {
      stopRain = hourlyRain[arrivalHourIndex];
    }

    return StopWeatherItem(
      cityName: cityName,
      condition: condition,
      time: time,
      temperature: "${current?.temperature2M?.round() ?? 22}°",
      rain: "$stopRain%",
      humidity: "${current?.relativeHumidity2M ?? 50}%",
      wind: "${current?.windSpeed10M?.round() ?? 10} km/h",
      weatherIcon: icon,
      cardColor: cardColor,
      iconColor: iconColor,
    );
  }

  // Map WMO Weather Codes to human readable conditions
  String _getConditionText(int code) {
    if (code == 0) return "Sunny";
    if (code >= 1 && code <= 3) return "Partly cloudy";
    if (code == 45 || code == 48) return "Foggy";
    if (code >= 51 && code <= 55) return "Light drizzle";
    if (code >= 61 && code <= 65) return "Light rain";
    if (code >= 80 && code <= 82) return "Rain showers";
    if (code >= 95 && code <= 99) return "Thunderstorm";
    return "Cloudy";
  }

  // Map WMO Weather Codes to Flutter Icons
  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code >= 1 && code <= 3) return Icons.wb_cloudy_rounded;
    if (code >= 51 && code <= 67) return Icons.cloudy_snowing;
    if (code >= 80 && code <= 82) return Icons.grain_rounded;
    if (code >= 95 && code <= 99) return Icons.thunderstorm_rounded;
    return Icons.wb_cloudy_rounded;
  }

  // Fallback demo data if offline
  void _loadFallbackData() {
    rainPercentages.assignAll(['5%', '15%', '45%', '70%', '80%', '40%']);
    hours.assignAll(['8 AM', '9 AM', '10 AM', '11 AM', '12 PM', '1 PM']);
    rainBarHeights.assignAll([5, 12, 35, 55, 60, 30]);

    weatherStops.assignAll([
      StopWeatherItem(
        cityName: 'Lahore',
        condition: 'Sunny',
        time: '8:00 AM',
        temperature: '24°',
        rain: '5%',
        humidity: '48%',
        wind: '9 km/h',
        weatherIcon: Icons.wb_sunny_rounded,
        cardColor: const Color(0xffFFF8DF),
        iconColor: const Color(0xffE9A323),
      ),
      StopWeatherItem(
        cityName: 'Gujranwala',
        condition: 'Partly cloudy',
        time: '9:15 AM',
        temperature: '22°',
        rain: '20%',
        humidity: '55%',
        wind: '12 km/h',
        weatherIcon: Icons.wb_cloudy_rounded,
        cardColor: const Color(0xffF0F4FA),
        iconColor: const Color(0xff6387B4),
      ),
      StopWeatherItem(
        cityName: 'Gujrat',
        condition: 'Light rain',
        time: '10:30 AM',
        temperature: '19°',
        rain: '60%',
        humidity: '78%',
        wind: '15 km/h',
        weatherIcon: Icons.cloudy_snowing,
        cardColor: const Color(0xffE4EFFF),
        iconColor: AppColors.primary,
      ),
    ]);
  }
}