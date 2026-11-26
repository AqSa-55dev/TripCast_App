
class ApiEndpoints {
  static const String geocodingBaseUrl =
      "https://geocoding-api.open-meteo.com/v1";

  static const String weatherBaseUrl =
      "https://api.open-meteo.com/v1";

  // Search cities by name
  static String searchCitiesUrl(String cityName) {
    return "$geocodingBaseUrl/search?name=${Uri.encodeComponent(cityName)}&count=10&language=en&format=json";
  }

  // Weather forecast for route stops
  static String getWeatherForecastUrl({
    required double latitude,
    required double longitude,
  }) {
    return "$weatherBaseUrl/forecast"
        "?latitude=$latitude"
        "&longitude=$longitude"
        "&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m"
        "&hourly=temperature_2m,precipitation_probability,weather_code"
        "&forecast_days=16"
        "&timezone=auto";
  }

  // Reverse geocoding for intermediate route stops
  static String reverseGeocodeUrl({
    required double latitude,
    required double longitude,
    required String accessToken,
  }) {
    return "https://api.mapbox.com/geocoding/v5/mapbox.places/$longitude,$latitude.json?types=place,locality&limit=1&access_token=$accessToken";
  }
}
