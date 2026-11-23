
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/route_details_model.dart';

class MapboxService {
  static const double startLongitude = 74.3587;
  static const double startLatitude = 31.5204;

  static const double endLongitude = 73.0479;
  static const double endLatitude = 33.6844;

  Future<RouteDetails> getRoute({
    required String accessToken,
  }) async {
    final url = Uri.parse(
      'https://api.mapbox.com/directions/v5/mapbox/driving/'
          '$startLongitude,$startLatitude;'
          '$endLongitude,$endLatitude'
          '?geometries=geojson'
          '&overview=full'
          '&access_token=$accessToken',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Get the first route
      final route = data['routes'][0];

      // Get route coordinates
      final coordinates = route['geometry']['coordinates'];

      final routeCoordinates = List<List<double>>.from(
        coordinates.map(
              (point) =>
          List<double>.from(
            point.map((value) => (value as num).toDouble()),
          ),
        ),
      );

      // Convert meters into kilometers
      final distanceKm =
      (route['distance'] / 1000).round();

      // Convert seconds into hours and minutes
      final totalMinutes =
      (route['duration'] / 60).round();

      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;

      String durationText;

      if (hours > 0) {
        durationText = '${hours}h ${minutes}m';
      } else {
        durationText = '${minutes}m';
      }

      return RouteDetails(
        coordinates: routeCoordinates,
        distance: '$distanceKm km',
        duration: durationText,
      );
    } else {
      throw Exception(
        'Failed to fetch route: ${response.statusCode}',
      );
    }
  }
}