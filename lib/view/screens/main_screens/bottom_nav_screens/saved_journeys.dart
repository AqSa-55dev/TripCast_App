import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../../controller/saved_journeys_controller.dart';
import '../../../../model/city_search_model.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/custom_small_circle_button.dart';
import '../../../components/custom_status_badge.dart';
import '../weather_on_route.dart';

class SavedJourneys extends StatefulWidget {
  // Callback to switch to Explore tab when "Plan a journey" is tapped
  final VoidCallback? onPlanTap;

  const SavedJourneys({super.key, this.onPlanTap});

  @override
  State<SavedJourneys> createState() => _SavedJourneysState();
}

class _SavedJourneysState extends State<SavedJourneys> {
  final SavedJourneysController savedController =
      Get.put(SavedJourneysController());

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            "Delete Journey?",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          content: Text(
            "Are you sure you want to remove this saved journey?",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.muted,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                savedController.deleteJourney(index); // Delete from storage
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: true,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Saved journeys",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),

              SizedBox(height: 4.h),

              Obx(
                () => Text(
                  "${savedController.savedJourneys.length} routes saved",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.muted,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Expanded(
                child: Obx(() {
                  if (savedController.savedJourneys.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 16.h),
                    itemCount: savedController.savedJourneys.length,
                    itemBuilder: (context, index) {
                      final item = savedController.savedJourneys[index];
                      return _buildSavedJourneyCard(item, index);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Saved Journey Card
  Widget _buildSavedJourneyCard(Map<String, dynamic> item, int index) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${item['from']}  →  ${item['to']}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),

              // Custom Status Badge (Suitable / Caution / Unfavorable)
              CustomStatusBadge(
                status: item['status'] ?? "Caution",
              ),
            ],
          ),

          SizedBox(height: 4.h),


          Text(
            item['date'] ?? "",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.muted,
            ),
          ),

          SizedBox(height: 12.h),

          // Journey Details Strip (Distance · Duration · Weather Note)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.veryLightBlue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Text(
                  item['distance'] ?? "",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Text(
                    "·",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                Text(
                  item['duration'] ?? "",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Text(
                    "·",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item['weather'] ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: Custombutton(
                  buttonText: "View journey",
                  buttonColor: AppColors.primary,
                  TextColor: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(25.r),
                  onButtonTap: () {
                    Get.to(
                      () => WeatherOnRoute(
                        startingLocation: Result(
                          name: item['from'] ?? "Lahore",
                          latitude: item['startLat'] ?? 31.5204,
                          longitude: item['startLng'] ?? 74.3587,
                        ),
                        destination: Result(
                          name: item['to'] ?? "Islamabad",
                          latitude: item['destLat'] ?? 33.6844,
                          longitude: item['destLng'] ?? 73.0479,
                        ),
                        departureDateTime: DateTime.now(),
                        distance: item['distance'] ?? "380 km",
                        duration: item['duration'] ?? "4 h 45 m",
                        weatherPoints: [
                          Position(
                            item['startLng'] ?? 74.3587,
                            item['startLat'] ?? 31.5204,
                          ),
                          Position(
                            item['destLng'] ?? 73.0479,
                            item['destLat'] ?? 33.6844,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(width: 10.w),

              CustomSmallCircleButton(
                isIcon: true,
                icon: Image.asset(
                  AppAssets.deleteIcon,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.red,
                ),
                onButtonTap: () {
                  _confirmDelete(index);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                color: AppColors.veryLightBlue,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                AppAssets.saveIcon,
                width: 44.w,
                height: 44.h,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 18.h),

            Text(
              "No saved journeys yet",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              "Plan and save your favorite routes to quickly check weather before traveling.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.muted,
                height: 1.4,
              ),
            ),

            SizedBox(height: 24.h),

            Custombutton(
              buttonText: "Plan a journey",
              buttonColor: AppColors.primary,
              TextColor: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(25.r),
              onButtonTap: () {
                if (widget.onPlanTap != null) {
                  widget.onPlanTap!();
                } else {
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
