
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:trip_cast/utils/mapbox_config.dart';

import '../services/mapBox_services/map_box_services.dart';

class JourneyMapController extends GetxController {

  // Mapbox service
  final MapboxService mapboxService = MapboxService();

  // Starting location: Lahore
  final Position startLocation = Position(
    74.3587,
    31.5204,
  );

  // Destination: Islamabad
  final Position endLocation = Position(
    73.0479,
    33.6844,
  );

  // Route coordinates returned by Mapbox
  final RxList<List<double>> routeCoordinates =
      <List<double>>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Error message
  final RxString errorMessage = ''.obs;

  //route details variables
  final RxString routeDistance = ''.obs;
  final RxString routeDuration = ''.obs;


  // Fetch route and route details from Mapbox Directions API
  Future<void> fetchRoute() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final route = await mapboxService.getRoute(
        accessToken: MapboxConfig.accessToken,
      );
      print("Route received successfully");
      print("Distance: ${route.distance}");
      print("Duration: ${route.duration}");

      // Saving route coordinates
      routeCoordinates.assignAll(route.coordinates);


      // Saving distance and duration
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
}
