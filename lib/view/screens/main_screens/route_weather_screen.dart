// Screen 13: Route Weather Screen ("Weather on your route")
// Design Specification: Page 14
// Architecture: MVC View consuming RouteWeatherController via GetX
// Location: lib/view/screens/main_screens/route_weather_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/route_weather_controller.dart';
import '../../../model/route_weather_model.dart';
import '../../../utils/app_colors.dart';
import '../../components/custom_button.dart';
import '../../components/custom_scaffold.dart';
import '../../components/custom_small_circle_button.dart';

class RouteWeatherScreen extends StatefulWidget {
  const RouteWeatherScreen({super.key});

  @override
  State<RouteWeatherScreen> createState() => _RouteWeatherScreenState();
}

class _RouteWeatherScreenState extends State<RouteWeatherScreen> {
  // Initialize RouteWeatherController using GetX
  final RouteWeatherController controller = Get.put(RouteWeatherController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: true,
      child: SafeArea(
        child: Obx(() {
          // Show circular loading when fetching weather data
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  16.verticalSpace,
                  Text(
                    "Checking weather along route...",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            );
          }

          final weatherData = controller.routeWeatherData.value;
          if (weatherData == null) {
            return const Center(child: Text("No weather data available"));
          }

          return Stack(
            children: [
              // 1. Scrollable Content
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      12.verticalSpace,

                      // Top App Bar: Back button and Screen Title
                      Row(
                        children: [
                          CustomSmallCircleButton(
                            isIcon: true,
                            icon: Icons.arrow_back_ios_new_outlined,
                            iconColor: AppColors.ink,
                            onButtonTap: () => Get.back(),
                          ),
                          16.horizontalSpace,
                          Text(
                            "Weather on your route",
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),

                      20.verticalSpace,

                      // Route Summary Banner (Primary Blue Card)
                      _buildRouteSummaryBanner(weatherData),

                      24.verticalSpace,

                      // Chance of Rain by Hour Section (Bar Chart)
                      _buildHourlyRainSection(weatherData.hourlyRainList),

                      24.verticalSpace,

                      // Stops Along The Way Section
                      Text(
                        "Stops along the way",
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      12.verticalSpace,

                      // List of 5 Stops Along the Route
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: weatherData.waypoints.length,
                        separatorBuilder: (context, index) => 12.verticalSpace,
                        itemBuilder: (context, index) {
                          final stop = weatherData.waypoints[index];
                          // Highlight the first stop (Lahore) with subtle amber/caution tint per Figma design
                          final bool isFirst = index == 0;
                          return _buildStopCard(stop: stop, isHighlighted: isFirst);
                        },
                      ),

                      // Space for bottom floating button
                      90.verticalSpace,
                    ],
                  ),
                ),
              ),

              // 2. Fixed Bottom Floating Action Button ("View AI recommendations")
              Positioned(
                left: 20.w,
                right: 20.w,
                bottom: 16.h,
                child: Custombutton(
                  buttonText: "✦  View AI recommendations",
                  buttonColor: AppColors.primary,
                  TextColor: AppColors.pureWhite,
                  showBoxShadow: true,
                  onButtonTap: () {
                    Get.snackbar(
                      "Gemini AI Advice",
                      "Opening AI travel recommendations for ${weatherData.originCity} to ${weatherData.destinationCity}...",
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Widget: Primary Blue Route Summary Banner
  Widget _buildRouteSummaryBanner(RouteWeatherModel data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Route names & departure timestamp
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${data.originCity} to ${data.destinationCity}",
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              4.verticalSpace,
              Text(
                data.dateSummary,
                style: TextStyle(
                  color: AppColors.pureWhite.withValues(alpha: 0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Right: Distance and duration
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.totalDistance,
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              4.verticalSpace,
              Text(
                data.totalDuration,
                style: TextStyle(
                  color: AppColors.pureWhite.withValues(alpha: 0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget: Chance of Rain by Hour Section with Bar Chart
  Widget _buildHourlyRainSection(List<HourlyRainItem> hourlyRain) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Chance of rain by hour",
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Along your trip",
                style: TextStyle(
                  color: AppColors.muted_grey,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          16.verticalSpace,

          // Rain Probability Histogram Bars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: hourlyRain.map((item) {
              return _buildRainBar(item);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Individual Vertical Rain Probability Capsule Bar
  Widget _buildRainBar(HourlyRainItem item) {
    final double barHeight = 75.h;
    final double fillFraction = (item.rainPercent / 100).clamp(0.05, 1.0);

    return Column(
      children: [
        // Percentage text on top
        Text(
          "${item.rainPercent}%",
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: item.rainPercent >= 50 ? AppColors.primary : AppColors.ink,
          ),
        ),

        6.verticalSpace,

        // Capsule Bar Container
        Container(
          width: 34.w,
          height: barHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FC),
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 34.w,
            height: barHeight * fillFraction,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),

        8.verticalSpace,

        // Hour Label below bar
        Text(
          item.timeLabel,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.muted_grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Widget: Stop Card along the route
  Widget _buildStopCard({
    required WaypointWeather stop,
    required bool isHighlighted,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isHighlighted
            ? const Color(0xFFFFF9EC) // Warm soft tint matching Lahore card in Figma
            : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isHighlighted
              ? const Color(0xFFFFE0A3)
              : AppColors.border_grey.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1: Condition Icon, City Name, Arrival Time & Big Temperature
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Weather Condition Icon container
              Container(
                height: 44.h,
                width: 44.w,
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? const Color(0xFFFFECC8)
                      : AppColors.sky_grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _getWeatherIcon(stop.conditionText),
                  color: isHighlighted ? const Color(0xFFD97706) : AppColors.primary,
                  size: 24.sp,
                ),
              ),

              12.horizontalSpace,

              // City and Arrival Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.cityName,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      "${stop.conditionText} · ${stop.arrivalTime}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.muted_grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Large Temperature display
              Text(
                "${stop.temperature.round()}°",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),

          14.verticalSpace,

          // Row 2: 3 Mini metrics cards (Rain, Humidity, Wind)
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: "Rain",
                  value: "${stop.rainProbability}%",
                  isRainHigh: stop.rainProbability >= 50,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: _buildMetricTile(
                  label: "Humidity",
                  value: "${stop.humidity}%",
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: _buildMetricTile(
                  label: "Wind",
                  value: "${stop.windSpeed.round()} km/h",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Mini Metric Tile inside stop card
  Widget _buildMetricTile({
    required String label,
    required String value,
    bool isRainHigh = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isRainHigh
            ? const Color(0xFFFEECEB) // Subtle light red when high rain chance
            : AppColors.veryLightBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: isRainHigh ? AppColors.red : AppColors.muted_grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          3.verticalSpace,
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: isRainHigh ? AppColors.red : AppColors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: map condition string to IconData
  IconData _getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains("sun") || lower.contains("clear")) {
      return Icons.wb_sunny_rounded;
    } else if (lower.contains("rain") || lower.contains("drizzle")) {
      return Icons.water_drop_rounded;
    } else if (lower.contains("storm") || lower.contains("thunder")) {
      return Icons.thunderstorm_rounded;
    } else if (lower.contains("snow")) {
      return Icons.ac_unit_rounded;
    } else {
      return Icons.wb_cloudy_rounded;
    }
  }
}
