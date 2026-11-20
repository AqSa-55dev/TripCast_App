
class ApiEndpoints {

  static const String geocodingBaseUrl =
      "https://geocoding-api.open-meteo.com/v1";


  static String searchCitiesUrl(String cityName) {
    return "$geocodingBaseUrl/search?name=${Uri.encodeComponent(cityName)}&count=10&language=en&format=json";
  }

}
