import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../controller/weather_controller.dart';
import '../../../model/city_search_model.dart';
import '../../../model/weather_model.dart';
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

    // It allows the initial widget build to finish before starting the weather request.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getRouteWeather(
        startingLocation: widget.startingLocation,
        //widget gives access to the properties passed into the WeatherOnRoute widget.
        destination: widget.destination,
        departureDateTime: widget.departureDateTime,
        duration: widget.duration,
        weatherPoints: widget.weatherPoints,
      );
    });
  }

  // Convert route duration, for example "1h 27m", into minutes
  int _getDurationInMinutes() {
    int totalMinutes = 0;
    //extract: Hours = 1, Minutes = 27
    final hMatch = RegExp(r'(\d+)\s*h').firstMatch(
      widget.duration,
    ); //(\d+): finds one or more digits.\s* allows optional spaces.
    final mMatch = RegExp(r'(\d+)\s*m').firstMatch(widget.duration);

    if (hMatch != null) {
      totalMinutes += int.parse(hMatch.group(1)!) * 60;
    }

    if (mMatch != null) {
      totalMinutes += int.parse(mMatch.group(1)!);
    }

    return totalMinutes > 0 ? totalMinutes : 60;
  }

  // Calculate the estimated arrival date and time for each stop
  DateTime _getStopArrivalTime(int stopIndex) {
    final int totalStops = controller.listOfStopsWeather.length;

    if (totalStops <= 1) {
      return widget.departureDateTime;
    }

    final int totalMinutes = _getDurationInMinutes();

    final int minutesAtStop = (totalMinutes * stopIndex / (totalStops - 1))
        .round();

    return widget.departureDateTime.add(Duration(minutes: minutesAtStop));
  }

  // Find the matching hourly forecast using date and hour
  int _findHourlyIndex(WeatherModel weather, DateTime targetTime) {
    final List<String> hourlyTimes = weather.hourly?.time ?? [];

    for (int i = 0; i < hourlyTimes.length; i++) {
      try {
        final DateTime forecastTime = DateTime.parse(hourlyTimes[i]);

        if (forecastTime.year == targetTime.year &&
            forecastTime.month == targetTime.month &&
            forecastTime.day == targetTime.day &&
            forecastTime.hour == targetTime.hour) {
          return i;
        }
      } catch (e) {
        // Skip an invalid forecast time
      }
    }

    return -1;
  }

  // Get a safe rain percentage for the selected hour
  String _getRainChance(WeatherModel weather, int hourIndex) {
    final rainList = weather.hourly?.precipitationProbability ?? [];

    if (hourIndex < 0 || hourIndex >= rainList.length) {
      return '--';
    }

    return '${rainList[hourIndex]}%';
  }

  bool _isDaytime(DateTime dateTime) {
    return dateTime.hour >= 6 && dateTime.hour < 18;
  }

  // Get weather condition and card styling
  _StopStyle _calculateStopStyle(int code, DateTime arrivalDateTime) {
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

    // Heavy rain
    if (code == 65 || code == 67 || code == 82) {
      return _StopStyle(
        condition: "Heavy rain",
        iconAsset: AppAssets.cloudRainIcon,
        iconColor: AppColors.primary,
        cardColor: AppColors.primarySoft_grey,
        borderColor: AppColors.softBlueBorder,
      );
    }

    // Light rain and drizzle
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

    // Fog
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
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
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

    // Partly cloudy
    if (code == 1 || code == 2) {
      return _StopStyle(
        condition: "Partly cloudy",
        iconAsset: AppAssets.partlyCloudyIcon,
        iconColor: AppColors.slate_blue,
        cardColor: AppColors.greyBlue,
        borderColor: AppColors.softGreyBlueBorder,
      );
    }

    // Clear weather
    // Clear weather
    if (code == 0) {
      return _StopStyle(
        condition: _isDaytime(arrivalDateTime) ? "Sunny" : "Clear",
        iconAsset: AppAssets.sunIcon,
        iconColor: AppColors.orange_yellow,
        cardColor: AppColors.warmYellow,
        borderColor: AppColors.warm_yellow_border,
      );
    }

    // Unknown or unavailable forecast
    return _StopStyle(
      condition: "Forecast unavailable",
      iconAsset: AppAssets.cloudIcon,
      iconColor: AppColors.muted_grey,
      cardColor: AppColors.greyBlue,
      borderColor: AppColors.softGreyBlueBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: true,
      bottomNavigationBar: BottomAppBar(
        height: 90.h,
        color: AppColors.pureWhite,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
          child: Custombutton(
            buttonText: '✧  View AI recommendations',
            buttonColor: AppColors.primary,
            TextColor: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(27.r),
            showBoxShadow: true,
            onButtonTap: () {
              Get.snackbar(
                "Gemini AI Advice",
                "Opening AI travel recommendations for route...",
              );
            },
          ),
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
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

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),

                  20.verticalSpace,

                  // Route Summary
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
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
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
                                fontSize: 16.sp,
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

                  // Chance of Rain by Hour
                  _buildRainChart(),

                  24.verticalSpace,

                  // Stops Heading
                  Text(
                    'Stops along the way',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),

                  14.verticalSpace,

                  // Weather Stops
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.listOfStopsWeather.length,
                    separatorBuilder: (context, index) => 14.verticalSpace,
                    itemBuilder: (context, index) {
                      final stopWeather = controller.listOfStopsWeather[index];

                      final stopInfo = controller.dynamicRouteStops[index];

                      // Get estimated arrival time at this stop
                      final DateTime arrivalDateTime = _getStopArrivalTime(
                        index,
                      );

                      final String arrivalTime = DateFormat('h:mm a')
                          .format(arrivalDateTime);

                      // Find forecast for this exact hour
                      final int hourIndex = _findHourlyIndex(
                        stopWeather,
                        arrivalDateTime,
                      );

                      // Read forecast values
                      final hourly = stopWeather.hourly;

                      final int code =
                          hourIndex >= 0 &&
                              hourly?.weatherCode != null &&
                              hourIndex < hourly!.weatherCode!.length
                          ? hourly.weatherCode![hourIndex]
                          : -1;

                      final double temperature =
                          hourIndex >= 0 &&
                              hourly?.temperature2M != null &&
                              hourIndex < hourly!.temperature2M!.length
                          ? hourly.temperature2M![hourIndex]
                          : stopWeather.current?.temperature2M ?? 0;

                      final String rainChance = _getRainChance(
                        stopWeather,
                        hourIndex,
                      );

                      final style = _calculateStopStyle(code, arrivalDateTime);

                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => StopForecast(
                              stopName: stopInfo['city'] ?? '',
                              stopIndex: index + 1,
                              totalStops: controller.listOfStopsWeather.length,
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
                          temperature: "${temperature.round()}°",
                          rain: rainChance,
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
                  15.verticalSpace,
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Build rain chart using actual hourly forecast timestamps
  Widget _buildRainChart() {
    if (controller.listOfStopsWeather.isEmpty) {
      return const SizedBox();
    }

    // Use the starting location's hourly forecast
    final WeatherModel weather = controller.listOfStopsWeather.first;

    final List<int> rainList = weather.hourly?.precipitationProbability ?? [];

    return Container(
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
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              Text(
                'Along your trip',
                style: TextStyle(fontSize: 12.sp, color: AppColors.muted),
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
              separatorBuilder: (context, index) => 10.horizontalSpace,
              itemBuilder: (context, index) {
                final DateTime slotTime = widget.departureDateTime.add(
                  Duration(hours: index),
                );

                final int hourIndex = _findHourlyIndex(weather, slotTime);

                final bool hasForecast =
                    hourIndex >= 0 && hourIndex < rainList.length;

                final int rainValue = hasForecast ? rainList[hourIndex] : 0;

                final double barHeight = hasForecast
                    ? (rainValue * 0.65).clamp(6.0, 68.0)
                    : 6.0;

                return SizedBox(
                  width: 42.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hasForecast ? "$rainValue%" : "--",
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
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Container(
                          height: barHeight.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: rainValue >= 50
                                ? AppColors.primary
                                : AppColors.soft_blue,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),

                      6.verticalSpace,

                      Text(
                        DateFormat('h a').format(slotTime),
                        style: TextStyle(
                          fontSize: 11.sp,
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
