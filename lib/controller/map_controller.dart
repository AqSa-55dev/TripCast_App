
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:trip_cast/utils/mapbox_config.dart';
import '../services/mapBox_services/map_box_services.dart';

class JourneyMapController extends GetxController {
  final MapboxService mapboxService = MapboxService();

  // These locations will now be provided when the journey is created.
  final Position startLocation;
  final Position endLocation;

  JourneyMapController({
    required this.startLocation,
    required this.endLocation,
  });


  final RxList<Position> weatherPoints = <Position>[].obs;
  final RxList<List<double>> routeCoordinates = <List<double>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString routeDistance = ''.obs;
  final RxString routeDuration = ''.obs;

  Future<void> fetchRoute() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final route = await mapboxService.getRoute(
        accessToken: MapboxConfig.accessToken,

        // Pass the selected starting and destination coordinates.

        startLongitude: startLocation.lng.toDouble(),
        startLatitude: startLocation.lat.toDouble(),
        endLongitude: endLocation.lng.toDouble(),
        endLatitude: endLocation.lat.toDouble(),
      );

      print("Route received successfully");
      print("Distance: ${route.distance}");
      print("Duration: ${route.duration}");

      routeCoordinates.assignAll(route.coordinates);
      _generateWeatherPoints(route.coordinates);
      routeDistance.value = route.distance;
      routeDuration.value = route.duration;

      print("Saved distance: ${routeDistance.value}");
      print("Saved duration: ${routeDuration.value}");
    } catch (e) {
      errorMessage.value = e.toString();
      print('Route fetching error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  double calculateDistance(
      List<double> point1,
      List<double> point2,
      ) {
    const earthRadius = 6371000.0;

    final lat1 = point1[1] * math.pi / 180;
    final lat2 = point2[1] * math.pi / 180;

    final latDifference =
        (point2[1] - point1[1]) * math.pi / 180;

    final lngDifference =
        (point2[0] - point1[0]) * math.pi / 180;

    final a =
        math.pow(math.sin(latDifference / 2), 2) +
            math.cos(lat1) *
                math.cos(lat2) *
                math.pow(math.sin(lngDifference / 2), 2);

    final c = 2 * math.atan2(
      math.sqrt(a),
      math.sqrt(1 - a),
    );

    return earthRadius * c;
  }
  double calculateTotalDistance(List<List<double>> coordinates) {
    double totalDistance = 0;

    for (int i = 0; i < coordinates.length - 1; i++) {
      totalDistance += calculateDistance(
        coordinates[i],
        coordinates[i + 1],
      );
    }

    return totalDistance;
  }


  void _generateWeatherPoints(List<List<double>> coordinates) {
    // Remove weather points from any previous route.
    weatherPoints.clear();

    // We need at least 3 coordinates.
    if (coordinates.length < 3) return;

    // Step 1: Calculate total route distance.
    final totalDistance = calculateTotalDistance(coordinates);

    // Step 2: Decide how many weather points to generate.
    const minimumSpacing = 50000.0; // 50 km in metres

    final numberOfPoints =
    ((totalDistance / minimumSpacing).floor() - 1)
        .clamp(0, 5)
        .toInt();

    if (numberOfPoints == 0) return;

    // Step 3: Calculate the distance between target points.
    final distanceBetweenPoints =
        totalDistance / (numberOfPoints + 1);

    // Step 4: Track our progress along the route.
    double travelledDistance = 0;
    int nextPoint = 1;

    // Step 5: Go through every route segment.
    for (int i = 0; i < coordinates.length - 1; i++) {
      final startCoordinate = coordinates[i];
      final endCoordinate = coordinates[i + 1];

      // Calculate distance of the current segment.
      final segmentDistance = calculateDistance(
        startCoordinate,
        endCoordinate,
      );

      // Remember distance before travelling this segment.
      final previousTravelledDistance = travelledDistance;

      // Add current segment distance.
      travelledDistance += segmentDistance;

      // Step 6: Check whether this segment contains a target.
      while (nextPoint <= numberOfPoints) {
        final targetDistance =
            distanceBetweenPoints * nextPoint;

        // Target has not been reached yet.
        if (targetDistance > travelledDistance) {
          break;
        }

        // Step 7: Calculate how far into this segment
        // the target point is located.
        final distanceIntoSegment =
            targetDistance - previousTravelledDistance;

        // Calculate the fraction of the segment travelled.
        final fraction = segmentDistance == 0
            ? 0.0
            : (distanceIntoSegment / segmentDistance)
            .clamp(0.0, 1.0)
            .toDouble();

        // Step 8: Interpolate longitude and latitude.
        final longitude =
            startCoordinate[0] +
                (endCoordinate[0] - startCoordinate[0]) * fraction;

        final latitude =
            startCoordinate[1] +
                (endCoordinate[1] - startCoordinate[1]) * fraction;

        // Step 9: Store the new weather point.
        weatherPoints.add(
          Position(longitude, latitude),
        );

        // Move on to the next target.
        nextPoint++;
      }

      // Stop when all weather points have been generated.
      if (nextPoint > numberOfPoints) {
        break;
      }
    }

    print("Weather points: ${weatherPoints.length}");
  }

}
