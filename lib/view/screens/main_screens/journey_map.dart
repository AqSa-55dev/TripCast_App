
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_button.dart';
import 'package:trip_cast/view/components/custom_status_badge.dart';
import 'package:trip_cast/view/screens/main_screens/weather_on_route.dart';

import '../../../controller/map_controller.dart';
import '../../../model/city_search_model.dart';
import '../../components/custom_small_circle_button.dart';

class JourneyMap extends StatefulWidget {
  final Result startingLocation;
  final Result destination;
  final DateTime departureDateTime;

  const JourneyMap({
    super.key,
    required this.startingLocation,
    required this.destination,
    required this.departureDateTime,
  });

  @override
  State<JourneyMap> createState() => _JourneyMapState();
}

class _JourneyMapState extends State<JourneyMap> {
  MapboxMap? mapboxMapController;
  late JourneyMapController journeyController;

  Offset? startLabelPosition;
  Offset? endLabelPosition;

  int selectedIndex = 0;
  bool isRouteDrawn = false;

  @override
  void initState() {
    super.initState();

    journeyController = Get.put(
      JourneyMapController(
        startLocation: Position(
          widget.startingLocation.longitude!,
          widget.startingLocation.latitude!,
        ),
        endLocation: Position(
          widget.destination.longitude!,
          widget.destination.latitude!,
        ),
      ),
      tag: 'journeyMap',
    );
  }

  Future<void> zoomMap(double amount) async {
    if (mapboxMapController == null) return;

    final camera = await mapboxMapController!.getCameraState();

    await mapboxMapController!.setCamera(
      CameraOptions(
        zoom: camera.zoom + amount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen Mapbox
          Positioned.fill(
            child: MapWidget(
              onMapCreated: _onMapCreated,
              onStyleLoadedListener: _onStyleLoaded,
              onCameraChangeListener: (data) {
                updateLabelPositions();
              },
            ),
          ),

          // Starting location label
          if (startLabelPosition != null)
            Positioned(
              left: startLabelPosition!.dx,
              top: startLabelPosition!.dy,
              child: IgnorePointer(
                child: placeLabel(
                  widget.startingLocation.name ?? 'Starting point',
                ),
              ),
            ),

          // Destination label
          if (endLabelPosition != null)
            Positioned(
              left: endLabelPosition!.dx,
              top: endLabelPosition!.dy,
              child: IgnorePointer(
                child: placeLabel(
                  widget.destination.name ?? 'Destination',
                ),
              ),
            ),

          // Top navigation bar
          Positioned(
            top: 25,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                CustomSmallCircleButton(
                  isIcon: true,
                  icon: Icons.arrow_back_ios_new_outlined,
                  iconColor: AppColors.ink,
                  onButtonTap: () {
                    Get.back();
                  },
                ),

                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    "${widget.startingLocation.name ?? 'starting point'} "
                        "to ${widget.destination.name ?? 'Destination'}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                ),

                CustomSmallCircleButton(
                  isIcon: true,
                  icon: Icons.favorite_border_outlined,
                  iconColor: AppColors.primary,
                ),
              ],
            ),
          ),

          // Bottom draggable sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.30,
              minChildSize: 0.20,
              maxChildSize: 0.50,
              builder: (context, scrollController) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                      ),
                      child: Column(
                        children: [
                          10.verticalSpace,

                          // Drag handle
                          Container(
                            margin: EdgeInsets.all(8),
                            height: 5.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),

                          15.verticalSpace,

                          // Journey information
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Text(
                                    "${widget.startingLocation.name ?? 'starting point'} "
                                        "to ${widget.destination.name ?? 'Destination'}",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.ink,
                                    ),
                                  ),

                                  Text(
                                    "${DateFormat('EEE d MMM').format(widget.departureDateTime)}"
                                        " · Depart "
                                        "${DateFormat('h:mm a').format(widget.departureDateTime)}",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.muted_grey,
                                    ),
                                  ),
                                ],
                              ),

                              CustomStatusBadge(),
                            ],
                          ),

                          SizedBox(height: 15.h),

                          // Journey details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            spacing: 10,
                            children: [
                              Obx(
                                    () => ShortDetailCard(
                                  "Distance",
                                  journeyController.routeDistance.value.isEmpty
                                      ? "Loading..."
                                      : journeyController.routeDistance.value,
                                ),
                              ),

                              Obx(
                                    () => ShortDetailCard(
                                  "Duration",
                                  journeyController.routeDuration.value.isEmpty
                                      ? "Loading..."
                                      : journeyController.routeDuration.value,
                                ),
                              ),

                              Obx(() {
                                return ShortDetailCard(
                                  "Weather points",
                                  journeyController.weatherPoints.length.toString(),
                                );
                              }),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          // Weather Details button
                          Custombutton(
                            buttonText: "Weather Details",
                            buttonColor: AppColors.pureWhite,
                            TextColor: AppColors.primary,
                            BorderColor: AppColors.primary,
                            onButtonTap: () {
                              Get.to(
                                () => WeatherOnRoute(
                                  startingLocation: widget.startingLocation,
                                  destination: widget.destination,
                                  departureDateTime: widget.departureDateTime,
                                  distance:
                                      journeyController.routeDistance.value,
                                  duration:
                                      journeyController.routeDuration.value,
                                  weatherPoints: journeyController.weatherPoints
                                      .toList(),
                                ),
                              );
                            },
                          ),

                          10.verticalSpace,

                          // AI Recommendations button
                          Custombutton(
                            buttonText: "AI Recommendations",
                            buttonColor: AppColors.primary,
                            TextColor: AppColors.pureWhite,
                            showBoxShadow: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Zoom buttons
          Positioned(
            bottom: 300,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: ToggleButtons(
                direction: Axis.vertical,
                isSelected: [
                  selectedIndex == 0,
                  selectedIndex == 1,
                ],
                onPressed: (index) {
                  setState(() {
                    selectedIndex = index;
                  });

                  if (index == 0) {
                    zoomMap(1);
                  } else {
                    zoomMap(-1);
                  }
                },
                borderRadius: BorderRadius.circular(22.r),
                selectedColor: AppColors.ink,
                fillColor: AppColors.pureWhite,
                color: AppColors.ink,
                constraints: const BoxConstraints(
                  minHeight: 45,
                  minWidth: 45,
                ),
                children: const [
                  Icon(Icons.add),
                  Icon(Icons.remove),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Map creation
  void _onMapCreated(MapboxMap controller) async {
    mapboxMapController = controller;

    await mapboxMapController?.location.updateSettings(
      LocationComponentSettings(enabled: true),
    );
  }

  // Add starting and destination markers
  Future<void> _addLocationMarkers() async {
    final startGeoJson = jsonEncode({
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Point",
        "coordinates": [
          journeyController.startLocation.lng,
          journeyController.startLocation.lat,
        ],
      },
    });

    final endGeoJson = jsonEncode({
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Point",
        "coordinates": [
          journeyController.endLocation.lng,
          journeyController.endLocation.lat,
        ],
      },
    });

    // Starting location source
    await mapboxMapController?.addSource(
      GeoJsonSource(
        id: "start-marker-source",
        data: startGeoJson,
      ),
    );

    // Destination source
    await mapboxMapController?.addSource(
      GeoJsonSource(
        id: "end-marker-source",
        data: endGeoJson,
      ),
    );

    // Starting marker
    await mapboxMapController?.addLayer(
      CircleLayer(
        id: "start-marker-layer",
        sourceId: "start-marker-source",
        circleRadius: 18,
        circleColor: AppColors.primary.value,
        circleStrokeColor: AppColors.pureWhite.value,
        circleStrokeWidth: 3,
      ),
    );

    // Destination marker
    await mapboxMapController?.addLayer(
      CircleLayer(
        id: "end-marker-layer",
        sourceId: "end-marker-source",
        circleRadius: 18,
        circleColor: AppColors.ink.value,
        circleStrokeColor: AppColors.pureWhite.value,
        circleStrokeWidth: 3,
      ),
    );

    // Letter A
    await mapboxMapController?.addLayer(
      SymbolLayer(
        id: "start-letter-layer",
        sourceId: "start-marker-source",
        textField: "A",
        textSize: 15,
        textColor: AppColors.pureWhite.value,
        textAnchor: TextAnchor.CENTER,
        textAllowOverlap: true,
      ),
    );

    // Letter B
    await mapboxMapController?.addLayer(
      SymbolLayer(
        id: "end-letter-layer",
        sourceId: "end-marker-source",
        textField: "B",
        textSize: 15,
        textColor: AppColors.pureWhite.value,
        textAnchor: TextAnchor.CENTER,
        textAllowOverlap: true,
      ),
    );

    debugPrint("Start and destination markers added!");
  }

  // Add weather markers
  Future<void> _addWeatherMarkers() async {
    final points = journeyController.weatherPoints;

    final weatherGeoJson = jsonEncode({
      "type": "FeatureCollection",
      "features": List.generate(points.length, (index) {
        final point = points[index];

        return {
          "type": "Feature",
          "properties": {
            "number": index + 1,
          },
          "geometry": {
            "type": "Point",
            "coordinates": [
              point.lng,
              point.lat,
            ],
          },
        };
      }),
    });

    // Weather points source
    await mapboxMapController?.addSource(
      GeoJsonSource(
        id: "weather-points-source",
        data: weatherGeoJson,
      ),
    );

    debugPrint("Weather points source added!");

    // Weather circular markers
    await mapboxMapController?.addLayer(
      CircleLayer(
        id: "weather-points-circle-layer",
        sourceId: "weather-points-source",
        circleRadius: 14,
        circleColor: AppColors.pureWhite.value,
        circleStrokeColor: AppColors.primary.value,
        circleStrokeWidth: 3,
      ),
    );

    // Weather point numbers
    await mapboxMapController?.addLayer(
      SymbolLayer(
        id: "weather-points-number-layer",
        sourceId: "weather-points-source",
        textField: "{number}",
        textSize: 13,
        textColor: AppColors.primary.value,
        textAnchor: TextAnchor.CENTER,
        textAllowOverlap: true,
        textIgnorePlacement: true,
      ),
    );
  }

  // Load route when Mapbox style is ready
  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    if (isRouteDrawn) return;

    try {
      // Fetch route coordinates
      await journeyController.fetchRoute();

      // Get route coordinates
      final coordinates =
      journeyController.routeCoordinates.toList();

      if (coordinates.isEmpty) {
        debugPrint("No route coordinates received");
        return;
      }

      // Convert route into GeoJSON
      final geoJson = jsonEncode({
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "LineString",
          "coordinates": coordinates,
        },
      });

      // Add route source
      await mapboxMapController?.addSource(
        GeoJsonSource(
          id: "journey-route",
          data: geoJson,
        ),
      );

      // Draw route line
      await mapboxMapController?.addLayer(
        LineLayer(
          id: "journey-route-layer",
          sourceId: "journey-route",
          lineColor: AppColors.primary.value,
          lineWidth: 6.0,
          lineCap: LineCap.ROUND,
          lineJoin: LineJoin.ROUND,
        ),
      );

      await _addLocationMarkers();
      await _addWeatherMarkers();

      isRouteDrawn = true;

      await fitRouteOnMap();

      debugPrint("Route drawn successfully!");
    } catch (e) {
      debugPrint("Error drawing route: $e");
    }
  }

  // Update starting and destination label positions
  Future<void> updateLabelPositions() async {
    if (mapboxMapController == null) return;

    // Starting location screen position
    final start = await mapboxMapController!.pixelForCoordinate(
      Point(
        coordinates: journeyController.startLocation,
      ),
    );

    // Destination screen position
    final end = await mapboxMapController!.pixelForCoordinate(
      Point(
        coordinates: journeyController.endLocation,
      ),
    );

    if (!mounted) return;

    setState(() {
      startLabelPosition = Offset(start.x + 23, start.y - 15);
      endLabelPosition = Offset(end.x + 23, end.y - 15);
    });
  }

  // Fit complete route on map
  Future<void> fitRouteOnMap() async {
    if (mapboxMapController == null) return;

    // Get route coordinates
    final points = journeyController.routeCoordinates.map((coordinate) {
      return Point(
        coordinates: Position(
          coordinate[0],
          coordinate[1],
        ),
      );
    }).toList();

    // Calculate camera position
    final camera =
    await mapboxMapController!.cameraForCoordinatesPadding(
      points,
      CameraOptions(),
      MbxEdgeInsets(
        top: 100,
        left: 30,
        bottom: MediaQuery.of(context).size.height * 0.35,
        right: 30,
      ),
      8,
      null,
    );

    // Move camera to show complete route
    await mapboxMapController!.setCamera(camera);

    // Update place labels
    await updateLabelPositions();
  }
}

// Journey detail card
Widget ShortDetailCard(String Heading, String Value) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.veryLightBlue,
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          Heading,
          style: TextStyle(
            color: AppColors.muted_grey,
            fontSize: 11.sp,
            fontWeight: FontWeight(700),
          ),
        ),
        Text(
          Value,
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 13.sp,
            fontWeight: FontWeight(900),
          ),
        ),
      ],
    ),
  );
}

// Map location label
Widget placeLabel(String name) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 7,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      name,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
