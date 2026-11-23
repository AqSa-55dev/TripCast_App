// Model representing weather and rain probabilities along a journey route
// Location: lib/model/route_weather_model.dart

class RouteWeatherModel {
  final String originCity;
  final String destinationCity;
  final String dateSummary;
  final String totalDistance;
  final String totalDuration;
  final List<HourlyRainItem> hourlyRainList;
  final List<WaypointWeather> waypoints;

  RouteWeatherModel({
    required this.originCity,
    required this.destinationCity,
    required this.dateSummary,
    required this.totalDistance,
    required this.totalDuration,
    required this.hourlyRainList,
    required this.waypoints,
  });
}

// Hourly rain probability item for bar chart
class HourlyRainItem {
  final String timeLabel;
  final int rainPercent;

  HourlyRainItem({
    required this.timeLabel,
    required this.rainPercent,
  });
}

// Weather detail at an individual route stop / waypoint
class WaypointWeather {
  final String cityName;
  final String arrivalTime;
  final double temperature;
  final int weatherCode;
  final String conditionText;
  final int rainProbability;
  final int humidity;
  final double windSpeed;

  WaypointWeather({
    required this.cityName,
    required this.arrivalTime,
    required this.temperature,
    required this.weatherCode,
    required this.conditionText,
    required this.rainProbability,
    required this.humidity,
    required this.windSpeed,
  });

  // Factory to parse from Open-Meteo API response JSON
  factory WaypointWeather.fromOpenMeteoJson({
    required String cityName,
    required String arrivalTime,
    required Map<String, dynamic> json,
  }) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final hourly = json['hourly'] as Map<String, dynamic>? ?? {};

    final double temp = (current['temperature_2m'] is num)
        ? (current['temperature_2m'] as num).toDouble()
        : 22.0;

    final int code = (current['weather_code'] is num)
        ? (current['weather_code'] as num).toInt()
        : 0;

    final int hum = (current['relative_humidity_2m'] is num)
        ? (current['relative_humidity_2m'] as num).toInt()
        : 50;

    final double wind = (current['wind_speed_10m'] is num)
        ? (current['wind_speed_10m'] as num).toDouble()
        : 10.0;

    // Get first hourly precipitation probability if available
    int rainProb = 10;
    if (hourly['precipitation_probability'] is List &&
        (hourly['precipitation_probability'] as List).isNotEmpty) {
      rainProb = ((hourly['precipitation_probability'] as List).first as num?)?.toInt() ?? 10;
    }

    return WaypointWeather(
      cityName: cityName,
      arrivalTime: arrivalTime,
      temperature: temp,
      weatherCode: code,
      conditionText: mapWeatherCodeToText(code),
      rainProbability: rainProb,
      humidity: hum,
      windSpeed: wind,
    );
  }

  // WMO weather code to descriptive string
  static String mapWeatherCodeToText(int code) {
    if (code == 0) return "Sunny";
    if (code >= 1 && code <= 3) return "Partly cloudy";
    if (code == 45 || code == 48) return "Foggy";
    if (code >= 51 && code <= 55) return "Light drizzle";
    if (code >= 61 && code <= 65) return "Light rain";
    if (code >= 71 && code <= 77) return "Snow";
    if (code >= 80 && code <= 82) return "Rain showers";
    if (code >= 95 && code <= 99) return "Thunderstorm";
    return "Cloudy";
  }
}
