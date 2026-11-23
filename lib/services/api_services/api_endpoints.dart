
class ApiEndpoints {

  static const String geocodingBaseUrl =
      "https://geocoding-api.open-meteo.com/v1";

  static const String weatherBaseUrl =
      "https://api.open-meteo.com/v1";

  // Search cities by name (Geocoding API)
  static String searchCitiesUrl(String cityName) {
    return "$geocodingBaseUrl/search?name=${Uri.encodeComponent(cityName)}&count=10&language=en&format=json";
  }

  // Weather forecast endpoint for waypoints & hourly rain prediction
  static String getWeatherForecastUrl({
    required double latitude,
    required double longitude,
  }) {
    return "$weatherBaseUrl/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&hourly=temperature_2m,precipitation_probability,weather_code&timezone=auto";
  }

}
