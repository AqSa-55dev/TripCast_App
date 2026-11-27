import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trip_cast/controller/choose_location_controller.dart';
import 'package:trip_cast/view/components/custom_scaffold.dart';
import 'package:trip_cast/view/components/custom_small_circle_button.dart';
import 'package:trip_cast/view/components/custom_text_field.dart';

import '../../../model/city_search_model.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import 'bottom_nav_screens/Explore_screen.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}


class _ChooseLocationState extends State<ChooseLocation> {
  Future<void> _useCurrentLocation() async {
    try {
      // Step 1: Check whether location services are enabled.
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        Get.snackbar(
          "Location Disabled",
          "Please enable your phone's location service.",
        );
        return;
      }

      // Step 2: Check location permission.
      LocationPermission permission = await Geolocator.checkPermission();

      // If permission has not been granted, ask the user.
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // If the user permanently denied permission.
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Required",
          "Please allow location access from your phone settings.",
        );
        return;
      }

      // If permission is still denied.
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Permission Denied",
          "TripCast needs location permission to find your location.",
        );
        return;
      }

      // Step 3: Get the current GPS coordinates.
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Step 4: Convert coordinates into a readable address.
      final geocoding = Geocoding();

      List<Placemark> placemarks =
      await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Use the first matching address.
      final place = placemarks.first;

      // Step 5: Create a Result object using your existing model.
      final currentLocation = Result(
        name: place.locality ??
            place.subAdministrativeArea ??
            "Current Location",
        latitude: position.latitude,
        longitude: position.longitude,
        country: place.country,
        admin1: place.administrativeArea,
      );

      // Step 6: Return the selected location to the previous screen.
      Get.back(result: currentLocation);

    } catch (e) {
      Get.snackbar(
        "Location Error",
        "Unable to get your current location. Please try again.",
      );

      debugPrint("Current location error: $e");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  ChooseLocationController citySearchController = Get.put(ChooseLocationController());
  TextEditingController searchController=TextEditingController();

  // final List<Map<String, dynamic>> places = [
  //   {
  //     "icon": AppAssets.locationIcon,
  //     "iconBg": AppColors.soft_blue,
  //     "iconColor": AppColors.primary,
  //     "title": "Islamabad",
  //     "subtitle": "Islamabad Capital Territory, Pakistan"
  //   },
  //   {
  //     "icon": AppAssets.locationIcon,
  //     "iconBg": AppColors.soft_blue,
  //     "iconColor": AppColors.primary,
  //     "title": "Islamabad International Airport",
  //     "subtitle": "Airport, Islamabad"
  //   },
  // ];

  Widget placeCard({
    required String icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Image.asset(icon, scale: 2, color: iconColor),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.muted_grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: false,
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomSmallCircleButton(
                      isIcon: true,
                      icon: Icons.chevron_left_outlined,
                      iconColor: AppColors.ink,
                      onButtonTap: () {
                        Get.back();
                      },
                    ),
                    10.horizontalSpace,
                    Text(
                      "Choose Location",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),

                20.verticalSpace,

                CustomTextField(
                  hintText: "Search",
                  showBorder: true,
                  prefixIcon: Icons.search_rounded,
                  Controller: searchController,
                  onChanged: (value) {
                    if (value.trim().isNotEmpty) {
                      citySearchController.getSearchCities(value.trim());
                    } else {
                      citySearchController.listOfSearchCities.clear();
                    }
                  },
                ),

                10.verticalSpace,

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.soft_blue,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.soft_blue.withValues(alpha: 0.035),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(onTap: (){_useCurrentLocation();},
                    child: Row(
                        children: [
                          Image.asset(
                              AppAssets.currentLocationIcon,
                              scale: 2,
                              color: AppColors.ink,
                          ),
                          12.horizontalSpace,
                          Text(
                            "Use my current location",
                            style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                  ),
                ),

                12.verticalSpace,

                Text(
                  "RESULTS",
                  style: TextStyle(
                    color: AppColors.muted_grey,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                12.verticalSpace,

                Expanded(
                  child: Obx(() {

                    if (citySearchController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (citySearchController.listOfSearchCities.isEmpty) {
                      return const SizedBox();
                    }

                    return ListView.builder(
                      itemCount: citySearchController.listOfSearchCities.length,
                      itemBuilder: (context, index) {

                        final place = citySearchController.listOfSearchCities[index];

                        return placeCard(
                          icon: AppAssets.locationIcon,
                          iconBg: AppColors.soft_blue,
                          iconColor: AppColors.primary,
                          title: place.name ?? "",
                          subtitle: [
                            if (place.admin1 != null && place.admin1!.isNotEmpty)
                              place.admin1!,
                            if (place.country != null && place.country!.isNotEmpty)
                              place.country!,
                          ].join(", "),
                          onTap: () {
                            Get.back(result: place);

                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          )
      ),
    );
  }
}
