
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/route_details_model.dart';

class MapboxService {

  Future<RouteDetails> getRoute({
    required String accessToken,
    required double startLongitude,
    required double startLatitude,
    required double endLongitude,
    required double endLatitude,
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

      if (data['routes'] == null || (data['routes'] as List).isEmpty) {
        throw Exception('No route found between these locations.');
      }

      final route = data['routes'][0];

      final coordinates = route['geometry']['coordinates'];

      final routeCoordinates = List<List<double>>.from(
        coordinates.map(
              (point) => List<double>.from(
            point.map((value) => (value as num).toDouble()),
          ),
        ),
      );

      final distanceKm = (route['distance'] / 1000).round();

      final totalMinutes = (route['duration'] / 60).round();

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