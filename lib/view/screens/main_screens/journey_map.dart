import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_button.dart';
import 'package:trip_cast/view/components/custom_status_badge.dart';

import '../../../controller/map_controller.dart';
import '../../components/custom_small_circle_button.dart';


class JourneyMap extends StatefulWidget {
  const JourneyMap({super.key});

  @override
  State<JourneyMap> createState() => _JourneyMapState();
}

class _JourneyMapState extends State<JourneyMap> {
  MapboxMap? mapboxMapController;
  late JourneyMapController journeyController;
  Offset? startLabelPosition;
  Offset? endLabelPosition;
  int selectedIndex=0;
  bool isRouteDrawn = false;

  @override
  void initState() {
    super.initState();

    journeyController = Get.put(JourneyMapController());
  }

  Future<void> zoomMap(double amount) async {
    if (mapboxMapController == null) return;

    // Get current zoom level
    final camera = await mapboxMapController!.getCameraState();

    // Increase or decrease zoom
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

            // 1. Full-screen Mapbox
            Positioned.fill(
              child: MapWidget(
                onMapCreated: _onMapCreated,
                onStyleLoadedListener: _onStyleLoaded,
                onCameraChangeListener: (data) {
                  updateLabelPositions();
                },
              ),
            ),if (startLabelPosition != null)
              Positioned(
                left: startLabelPosition!.dx,
                top: startLabelPosition!.dy,
                child: IgnorePointer(
                  child: placeLabel("Lahore"),
                ),
              ),

            if (endLabelPosition != null)
              Positioned(
                left: endLabelPosition!.dx,
                top: endLabelPosition!.dy,
                child: IgnorePointer(
                  child: placeLabel("Islamabad"),
                ),
              ),
            Positioned(top: 25,
                left: 20,
                right: 20,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,spacing: 10,
              children: [
              CustomSmallCircleButton(isIcon: true, icon: Icons.arrow_back_ios_new_outlined,iconColor: AppColors.ink,onButtonTap: (){Get.back();},),
              Container(padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(22.r),boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12), // Light, subtle shadow
                    blurRadius: 12, // Softness of the shadow
                    spreadRadius: 1, // How far the shadow extends
                    offset: const Offset(0, 4), // Moves shadow 4px down
                  ),
                ],
                ),
                child: Text("Lahore to Islamabad",style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),),),
              CustomSmallCircleButton(isIcon: true, icon: Icons.favorite_border_outlined,iconColor: AppColors.primary,),


            ],)),


            //  Bottom sheet
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

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column( crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Text(
                                      "Lahore to Islamabad",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.ink,
                                      ),
                                    ),

                                    Text(
                                      "Thu 12 Nov . Depart 8:00 AM",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.muted_grey,
                                      ),
                                    ),
                                  ],
                                ),
                                CustomStatusBadge()
                              ],
                            ),

                            SizedBox(height: 15.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              spacing:10,
                              children: [
                                Obx(() => ShortDetailCard(
                                  "Distance",
                                  journeyController.routeDistance.value.isEmpty
                                      ? "Loading..."
                                      : journeyController.routeDistance.value,
                                )),

                                Obx(() => ShortDetailCard(
                                  "Duration",
                                  journeyController.routeDuration.value.isEmpty
                                      ? "Loading..."
                                      : journeyController.routeDuration.value,
                                )),

                                ShortDetailCard("Weather points", "5"),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            Custombutton(
                              buttonText: "Weather Details",
                              buttonColor: AppColors.pureWhite,
                              TextColor: AppColors.primary,
                              BorderColor: AppColors.primary,
                            ),
                            10.verticalSpace,
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
              bottom:300,
              right: 15,
              child: Container(decoration: BoxDecoration(color: AppColors.pureWhite,borderRadius: BorderRadius.circular(22.r)),
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


  void _onMapCreated(MapboxMap controller) async {
    mapboxMapController = controller;

    await mapboxMapController?.location.updateSettings(
      LocationComponentSettings(enabled: true),
    );
  }

  Future<void> _addLocationMarkers() async {

    // 1. Create GeoJSON for Lahore
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

    // 2. Create GeoJSON for Islamabad
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

    // 3. Add Starting location source
    await mapboxMapController?.addSource(
      GeoJsonSource(
        id: "start-marker-source",
        data: startGeoJson,
      ),
    );

    // 4. Add Destination source
    await mapboxMapController?.addSource(
      GeoJsonSource(
        id: "end-marker-source",
        data: endGeoJson,
      ),
    );

    // 5. Draw Starting location marker (blue)
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

    // 6. Draw Destination marker (black)
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
    // Letter A inside the start marker
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

// Letter B inside the destination marker
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


  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {

    if (isRouteDrawn) return;

    try {
      // Fetch route coordinates
      await journeyController.fetchRoute();

      // Get coordinates from GetX controller
      final coordinates =
      journeyController.routeCoordinates.toList();

      if (coordinates.isEmpty) {
        debugPrint("No route coordinates received");
        return;
      }

      // Convert route coordinates into GeoJSON
      final geoJson = jsonEncode({
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "LineString",
          "coordinates": coordinates,
        },
      });

      // Add GeoJSON source
      await mapboxMapController?.addSource(
        GeoJsonSource(
          id: "journey-route",
          data: geoJson,
        ),
      );

      // Add route line layer
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
      isRouteDrawn = true;
      await fitRouteOnMap();


      debugPrint("Route drawn successfully!");

    } catch (e) {
      debugPrint("Error drawing route: $e");
    }
  }
  Future<void> updateLabelPositions() async {
    if (mapboxMapController == null) return;

    // Get starting location's screen position
    final start = await mapboxMapController!.pixelForCoordinate(
      Point(coordinates: journeyController.startLocation),
    );

    // Get destination's screen position
    final end = await mapboxMapController!.pixelForCoordinate(
      Point(coordinates: journeyController.endLocation),
    );

    if (!mounted) return;

    setState(() {
      startLabelPosition = Offset(start.x + 23, start.y - 15);
      endLabelPosition = Offset(end.x +23, end.y - 15);
    });
  }


  Future<void> fitRouteOnMap() async {
    if (mapboxMapController == null) return;

    // Get all route coordinates
    final points = journeyController.routeCoordinates.map((coordinate) {
      return Point(
        coordinates: Position(coordinate[0], coordinate[1]),
      );
    }).toList();

    // Calculate camera position
    final camera = await mapboxMapController!.cameraForCoordinatesPadding(
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

    // Move map to show the complete route
    await mapboxMapController!.setCamera(camera);

    // Update place labels
    await updateLabelPositions();
  }
}



Widget ShortDetailCard(String Heading, String Value){
  return Container(

    // width: 110.w,
    //height: 50.h,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(color: AppColors.veryLightBlue,borderRadius: BorderRadius.circular(15.r)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,spacing: 4,
      children: [

          Text(Heading,style: TextStyle(color: AppColors.muted_grey, fontSize: 11.sp, fontWeight: FontWeight(700)), ),
        Text(Value,style: TextStyle(color: AppColors.ink, fontSize: 13.sp, fontWeight: FontWeight(900)), ),

      ],
    ),

  );
}

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