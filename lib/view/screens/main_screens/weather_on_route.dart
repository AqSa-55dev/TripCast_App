
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../controller/weather_controller.dart';
import '../../../model/city_search_model.dart';
import '../../../utils/app_assets.dart';
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

    // Fetch weather for all stops along the route
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
    // Calculate hourly forecast index from departure date
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
        child: Obx(() {
          // Loading state
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

          // Get hourly rain probability from the first stop
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
                  // App Bar
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

                  // Route Summary Banner
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
                              widget.distance.isEmpty
                                  ? '--'
                                  : widget.distance,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.pureWhite,
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              widget.duration.isEmpty
                                  ? '--'
                                  : widget.duration,
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

                  // Chance of Rain by Hour
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

                        SizedBox(
                          height: 138.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: 6,
                            separatorBuilder: (context, index) =>
                            10.horizontalSpace,
                            itemBuilder: (context, index) {
                              final int targetIndex =
                                  startHourIndex + index;

                              final int rainValue =
                              targetIndex < hourlyRainList.length
                                  ? hourlyRainList[targetIndex]
                                  : 0;

                              final double barHeight =
                              (rainValue * 0.65).clamp(6.0, 68.0);

                              final DateTime slotTime =
                              widget.departureDateTime.add(
                                Duration(hours: index),
                              );

                              final String hourLabel =
                              DateFormat('h a').format(slotTime);

                              return SizedBox(
                                width: 42.w,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
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

                  // Dynamic Stops List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.listOfStopsWeather.length,
                    separatorBuilder: (context, index) =>
                    14.verticalSpace,
                    itemBuilder: (context, index) {
                      final stopWeather =
                      controller.listOfStopsWeather[index];

                      final stopInfo =
                      controller.dynamicRouteStops[index];

                      // Get weather condition code
                      final int code =
                          stopWeather.current?.weatherCode ?? 0;

                      // Get rain probability
                      final hourlyRain = stopWeather
                          .hourly?.precipitationProbability ??
                          [];

                      final int stopHourIndex =
                          startHourIndex + index;

                      final int rainChance =
                      stopHourIndex < hourlyRain.length
                          ? hourlyRain[stopHourIndex]
                          : 0;

                      // Get temperature
                      final double temp =
                          stopWeather.current?.temperature2M
                              ?.toDouble() ??
                              20.0;

                      final String arrivalTime =
                          stopInfo['time'] ?? '';

                      // Get card style according to weather condition
                      final style = _calculateStopStyle(
                        code: code,
                        rainChance: rainChance,
                      );

                      return GestureDetector(
                        onTap: () {
                          Get.to(
                                () => StopForecast(
                              stopName: stopInfo['city'] ?? '',
                              stopIndex: index + 1,
                              totalStops: controller
                                  .listOfStopsWeather.length,
                              arrivalTime: arrivalTime,
                              weatherModel: stopWeather,
                              departureDateTime:
                              widget.departureDateTime,
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
                          weatherIconAsset: style.iconAsset,
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

  // Weather card styling based on weather condition code
  _StopStyle _calculateStopStyle({
    required int code,
    required int rainChance,
  }) {
    // Thunderstorm
    if (code == 95 || code == 96 || code == 99) {
      return _StopStyle(
        condition: "Thunderstorm",
        iconAsset: AppAssets.cloudRainIcon,
        iconColor: AppColors.primary,
        cardColor: AppColors.primarySoft_grey,
        borderColor: AppColors.softBlueBorder,
      );
    }

    // Heavy Rain
    if (code == 65 ||
        code == 67 ||
        code == 82 ||
        rainChance >= 75) {
      return _StopStyle(
        condition: "Heavy rain",
        iconAsset: AppAssets.cloudRainIcon,
        iconColor: AppColors.primary,
        cardColor: AppColors.primarySoft_grey,
        borderColor: AppColors.softBlueBorder,
      );
    }

    // Light Rain
    if ((code >= 51 && code <= 57) ||
        (code >= 61 && code <= 63) ||
        code == 66 ||
        code == 80 ||
        code == 81) {
      return _StopStyle(
        condition: "Light rain",
        iconAsset: AppAssets.cloudRainIcon,
        iconColor: AppColors.primary,
        cardColor: AppColors.primarySoft_grey,
        borderColor: AppColors.softBlueBorder,
      );
    }

    // Foggy
    if (code == 45 || code == 48) {
      return _StopStyle(
        condition: "Foggy",
        iconAsset: AppAssets.cloudIcon,
        iconColor: AppColors.muted_grey,
        cardColor: AppColors.greyBlue,
        borderColor: AppColors.softGreyBlueBorder,
      );
    }

    // Snow
    if ((code >= 71 && code <= 77) ||
        code == 85 ||
        code == 86) {
      return _StopStyle(
        condition: "Snow",
        iconAsset: AppAssets.cloudIcon,
        iconColor: AppColors.slate_blue,
        cardColor: AppColors.greyBlue,
        borderColor: AppColors.softGreyBlueBorder,
      );
    }

    // Cloudy
    if (code == 3) {
      return _StopStyle(
        condition: "Cloudy",
        iconAsset: AppAssets.cloudIcon,
        iconColor: AppColors.slate_blue,
        cardColor: AppColors.greyBlue,
        borderColor: AppColors.softGreyBlueBorder,
      );
    }

    // Partly Cloudy
    if (code == 1 || code == 2) {
      return _StopStyle(
        condition: "Partly cloudy",
        iconAsset: AppAssets.partlyCloudyIcon,
        iconColor: AppColors.slate_blue,
        cardColor: AppColors.greyBlue,
        borderColor: AppColors.softGreyBlueBorder,
      );
    }

    // Sunny / Clear
    return _StopStyle(
      condition: "Sunny",
      iconAsset: AppAssets.sunIcon,
      iconColor: AppColors.orange_yellow,
      cardColor: AppColors.warmYellow,
      borderColor: AppColors.warm_yellow_border,
    );
  }
}

// Weather style for each stop card
class _StopStyle {
  final String condition;
  final String iconAsset;
  final Color iconColor;
  final Color cardColor;
  final Color borderColor;

  _StopStyle({
    required this.condition,
    required this.iconAsset,
    required this.iconColor,
    required this.cardColor,
    required this.borderColor,
  });
}
