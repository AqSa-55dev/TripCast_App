
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../controller/weather_controller.dart';
import '../../../model/city_search_model.dart';
import '../../../utils/app_colors.dart';
import '../../components/custom_button.dart';
import '../../components/custom_scaffold.dart';
import '../../components/custom_small_circle_button.dart';
import '../../components/weather_stop_card.dart';
import 'stop_forecast.dart';

class WeatherOnRoute extends StatefulWidget {
  final Result startingLocation;
  final Result destination;
  final DateTime departureDateTime;
  final String distance;
  final String duration;
  final List<Position> weatherPoints;

  const WeatherOnRoute({
    super.key,
    required this.startingLocation,
    required this.destination,
    required this.departureDateTime,
    required this.distance,
    required this.duration,
    required this.weatherPoints,
  });

  @override
  State<WeatherOnRoute> createState() => _WeatherOnRouteState();
}

class _WeatherOnRouteState extends State<WeatherOnRoute> {
  final WeatherController controller = Get.put(WeatherController());

  @override
  void initState() {
    super.initState();
    // Fetch live weather for dynamic route stops from JourneyMap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getRouteWeather(
        startingLocation: widget.startingLocation,
        destination: widget.destination,
        departureDateTime: widget.departureDateTime,
        duration: widget.duration,
        weatherPoints: widget.weatherPoints,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate day offset from today for accurate Open-Meteo hourly indexing
    final DateTime now = DateTime.now();
    final int daysOffset = DateTime(
      widget.departureDateTime.year,
      widget.departureDateTime.month,
      widget.departureDateTime.day,
    )
        .difference(DateTime(now.year, now.month, now.day))
        .inDays
        .clamp(0, 6);

    final int startHourIndex =
        (daysOffset * 24) + widget.departureDateTime.hour;

    return CustomScaffold(
      isBackgroundGradient: true,
      child: SafeArea(
        // Wrap with Obx for reactive state updates
        child: Obx(() {
          // Loading state while API is fetching data
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
                    'Checking weather along route...',
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

          // Extract hourly rain probabilities from origin city
          final List<int> hourlyRainList =
              controller.listOfStopsWeather.isNotEmpty
                  ? (controller.listOfStopsWeather.first.hourly
                          ?.precipitationProbability ??
                      [])
                  : [];

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar (Back button + Title)
                  Row(
                    children: [
                      CustomSmallCircleButton(
                        isIcon: true,
                        icon: Icons.arrow_back_ios_new_outlined,
                        iconColor: AppColors.ink,
                        onButtonTap: () {
                          Get.back();
                        },
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Text(
                          'Weather on your route',
                          style: TextStyle(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),

                  20.verticalSpace,

                  // Dynamic Route Summary Banner
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 17.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.startingLocation.name ?? "Origin"} to ${widget.destination.name ?? "Destination"}',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                              5.verticalSpace,
                              Text(
                                DateFormat('EEE, d MMM · Depart h:mm a')
                                    .format(widget.departureDateTime),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.distance.isEmpty ? '--' : widget.distance,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.pureWhite,
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              widget.duration.isEmpty ? '--' : widget.duration,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.pureWhite,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  20.verticalSpace,

                  // Chance of rain by hour (Dynamic ListView.separated)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Chance of rain by hour',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              'Along your trip',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),

                        16.verticalSpace,

                        // Dynamic 6-hour rain forecast starting from departure hour
                        SizedBox(
                          height: 138.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: 6,
                            separatorBuilder: (context, index) =>
                                10.horizontalSpace,
                            itemBuilder: (context, index) {
                              final int targetIndex = startHourIndex + index;
                              final int rainValue =
                                  (targetIndex < hourlyRainList.length)
                                      ? hourlyRainList[targetIndex]
                                      : 0;
                              final double barHeight =
                                  (rainValue * 0.65).clamp(6.0, 68.0);

                              final DateTime slotTime = widget.departureDateTime
                                  .add(Duration(hours: index));
                              final String hourLabel =
                                  DateFormat('h a').format(slotTime);

                              return SizedBox(
                                width: 42.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$rainValue%",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    6.verticalSpace,

                                    Container(
                                      height: 70.h,
                                      width: 36.w,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Container(
                                        height: barHeight.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: rainValue >= 50
                                              ? AppColors.primary
                                              : AppColors.soft_blue,
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                      ),
                                    ),

                                    6.verticalSpace,

                                    Text(
                                      hourLabel,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  24.verticalSpace,

                  // Stops Heading
                  Text(
                    'Stops along the way',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),

                  14.verticalSpace,

                  // Dynamic Stops along the way list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.listOfStopsWeather.length,
                    separatorBuilder: (context, index) => 14.verticalSpace,
                    itemBuilder: (context, index) {
                      final stopWeather = controller.listOfStopsWeather[index];
                      final stopInfo = controller.dynamicRouteStops[index];
                      final int code = stopWeather.current?.weatherCode ?? 0;

                      final hourlyRain =
                          stopWeather.hourly?.precipitationProbability ?? [];
                      final int stopHourIndex = startHourIndex + index;
                      final int rainChance =
                          (stopHourIndex < hourlyRain.length)
                              ? hourlyRain[stopHourIndex]
                              : 0;

                      final double temp =
                          stopWeather.current?.temperature2M?.toDouble() ?? 20.0;
                      final String arrivalTime = stopInfo['time'] ?? '';

                      // Calculate unified weather style based strictly on actual weather & temperature
                      final style = _calculateStopStyle(
                        code: code,
                        rainChance: rainChance,
                        temp: temp,
                        time: arrivalTime,
                      );

                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => StopForecast(
                              stopName: stopInfo['city'] ?? '',
                              stopIndex: index + 1,
                              totalStops:
                                  controller.listOfStopsWeather.length,
                              arrivalTime: arrivalTime,
                              weatherModel: stopWeather,
                              departureDateTime: widget.departureDateTime,
                            ),
                          );
                        },
                        child: WeatherStopCard(
                          cityName: stopInfo['city'] ?? '',
                          condition: style.condition,
                          time: arrivalTime,
                          temperature: "${temp.round()}°",
                          rain: "$rainChance%",
                          humidity:
                              "${stopWeather.current?.relativeHumidity2M ?? 0}%",
                          wind:
                              "${stopWeather.current?.windSpeed10M?.round() ?? 0} km/h",
                          weatherIcon: style.icon,
                          cardColor: style.cardColor,
                          borderColor: style.borderColor,
                          iconColor: style.iconColor,
                        ),
                      );
                    },
                  ),

                  24.verticalSpace,

                  // AI Recommendations Button
                  Custombutton(
                    buttonText: '✧  View AI recommendations',
                    buttonColor: AppColors.primary,
                    TextColor: AppColors.pureWhite,
                    showBoxShadow: true,
                    onButtonTap: () {
                      Get.snackbar(
                        "Gemini AI Advice",
                        "Opening AI travel recommendations for route...",
                      );
                    },
                  ),

                  15.verticalSpace,
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  _StopStyle _calculateStopStyle({
    required int code,
    required int rainChance,
    required double temp,
    required String time,
  }) {
    // Check if arrival time is night/early morning (e.g. 11 PM, 3 AM)
    final bool isNight = (time.contains("PM") &&
            (time.startsWith("8") ||
                time.startsWith("9") ||
                time.startsWith("10") ||
                time.startsWith("11"))) ||
        (time.contains("AM") &&
            (time.startsWith("12") ||
                time.startsWith("1") ||
                time.startsWith("2") ||
                time.startsWith("3") ||
                time.startsWith("4") ||
                time.startsWith("5")));

    // Rain / Storm
    if (rainChance >= 50 || (code >= 51 && code <= 99)) {
      final String label =
          (rainChance >= 75 || code >= 95) ? "Heavy rain" : "Light rain";
      return _StopStyle(
        condition: label,
        icon: Icons.grain_rounded,
        iconColor: AppColors.primary,
        cardColor: AppColors.primarySoft_grey,
        borderColor: AppColors.softBlueBorder,
      );
    }

    // Cold / Chilly
    if (temp <= 8.0) {
      return _StopStyle(
        condition: isNight ? "Cold · Clear" : "Chilly",
        icon: Icons.ac_unit_rounded,
        iconColor: AppColors.slate_blue,
        cardColor: AppColors.greyBlue,
        borderColor: AppColors.softGreyBlueBorder,
      );
    }

    // Foggy
    if (code == 45 || code == 48) {
      return _StopStyle(
        condition: "Foggy",
        icon: Icons.cloud,
        iconColor: AppColors.muted_grey,
        cardColor: AppColors.greyBlue,
        borderColor: AppColors.softGreyBlueBorder,
      );
    }

    // Cloudy / Partly Cloudy
    if (code >= 1 && code <= 3 || rainChance >= 20) {
      final String label = code == 3 ? "Cloudy" : "Partly cloudy";
      return _StopStyle(
        condition: label,
        icon: Icons.wb_cloudy_rounded,
        iconColor: AppColors.slate_blue,
        cardColor: AppColors.greyBlue,
        borderColor: AppColors.softGreyBlueBorder,
      );
    }

    // Sunny / Clear
    return _StopStyle(
      condition: isNight ? "Clear" : "Sunny",
      icon: isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded,
      iconColor: isNight? AppColors.slate_blue : AppColors.orange_yellow,
      cardColor: isNight? AppColors.transparentBlue :AppColors.warmYellow,
      borderColor: isNight? AppColors.slate_blue :AppColors.warm_yellow_border,
    );
  }
}

// Unified class for consistent stop card visuals
class _StopStyle {
  final String condition;
  final IconData icon;
  final Color iconColor;
  final Color cardColor;
  final Color borderColor;

  _StopStyle({
    required this.condition,
    required this.icon,
    required this.iconColor,
    required this.cardColor,
    required this.borderColor,
  });
}
