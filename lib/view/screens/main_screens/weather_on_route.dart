// Screen 13: Route Weather Screen ("Weather on your route")
// Design Specification: Page 14
// Architecture: MVC View connected to WeatherController via GetX Obx
// Location: lib/view/screens/main_screens/weather_on_route.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/weather_controller.dart';
import '../../../utils/app_colors.dart';
import '../../components/custom_button.dart';
import '../../components/custom_scaffold.dart';
import '../../components/custom_small_circle_button.dart';
import '../../components/weather_stop_card.dart';

class WeatherOnRoute extends StatefulWidget {
  const WeatherOnRoute({super.key});

  @override
  State<WeatherOnRoute> createState() => _WeatherOnRouteState();
}

class _WeatherOnRouteState extends State<WeatherOnRoute> {

  final WeatherController controller = Get.put(WeatherController());

  final List<String> hours = ['8 AM', '9 AM', '10 AM', '11 AM', '12 PM', '1 PM'];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: true,
      child: SafeArea(
        child: Obx(() {
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

          // Extract hourly rain probabilities from origin city (Lahore)
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
                                'Lahore to Islamabad',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                              5.verticalSpace,
                              Text(
                                'Thu, 12 Nov · Depart 8:00 AM',
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
                              '380 km',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.pureWhite,
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              '4 h 45 m',
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

                  // Chance of rain by hour
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
                            itemCount: hours.length,
                            separatorBuilder: (context, index) =>
                                10.horizontalSpace,
                            itemBuilder: (context, index) {
                              // 8 AM corresponds to index 8 in Open-Meteo 24-hour array
                              final int targetIndex = 8 + index;
                              final int rainValue =
                                  (targetIndex < hourlyRainList.length)
                                      ? hourlyRainList[targetIndex]
                                      : 0;
                              final double barHeight =
                                  (rainValue * 0.65).clamp(6.0, 68.0);

                              return SizedBox(
                                width: 40.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Percentage
                                    Text(
                                      "$rainValue%",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    6.verticalSpace,

                                    // Capsule bar container
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
                                      hours[index],
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

                  Text(
                    'Stops along the way',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),

                  14.verticalSpace,

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.listOfStopsWeather.length,
                    separatorBuilder: (context, index) => 14.verticalSpace,
                    itemBuilder: (context, index) {
                      final stopWeather = controller.listOfStopsWeather[index];
                      final stopInfo = controller.routeStops[index];
                      final int code = stopWeather.current?.weatherCode ?? 0;

                      // Get rain chance at arrival hour (8 AM + index)
                      final hourlyRain =
                          stopWeather.hourly?.precipitationProbability ?? [];
                      final int rainChance =
                          (8 + index < hourlyRain.length)
                              ? hourlyRain[8 + index]
                              : 0;

                      return WeatherStopCard(
                        cityName: stopInfo['city'],
                        condition: _getConditionText(code),
                        time: stopInfo['time'],
                        temperature:
                            "${stopWeather.current?.temperature2M?.round() ?? 0}°",
                        rain: "$rainChance%",
                        humidity:
                            "${stopWeather.current?.relativeHumidity2M ?? 0}%",
                        wind:
                            "${stopWeather.current?.windSpeed10M?.round() ?? 0} km/h",
                        weatherIcon: _getWeatherIcon(code),
                        cardColor: _getCardColor(code, index),
                        iconColor: _getIconColor(code, index),
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

  // Helper: Map WMO weather code to readable text
  String _getConditionText(int code) {
    if (code == 0) return "Sunny";
    if (code >= 1 && code <= 3) return "Partly cloudy";
    if (code == 45 || code == 48) return "Foggy";
    if (code >= 51 && code <= 55) return "Light drizzle";
    if (code >= 61 && code <= 65) return "Light rain";
    if (code >= 80 && code <= 82) return "Rain showers";
    if (code >= 95 && code <= 99) return "Thunderstorm";
    return "Cloudy";
  }

  // Helper: Map WMO weather code to IconData
  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code >= 1 && code <= 3) return Icons.wb_cloudy_rounded;
    if (code >= 51 && code <= 67) return Icons.cloudy_snowing;
    if (code >= 80 && code <= 82) return Icons.grain_rounded;
    if (code >= 95 && code <= 99) return Icons.thunderstorm_rounded;
    return Icons.wb_cloudy_rounded;
  }

  // Helper: Card background color
  Color _getCardColor(int code, int index) {
    if (code >= 51 && code <= 99) return const Color(0xffE4EFFF);
    if (index == 0) return const Color(0xffFFF8DF);
    return AppColors.pureWhite;
  }

  // Helper: Weather icon color
  Color _getIconColor(int code, int index) {
    if (code >= 51 && code <= 99) return AppColors.primary;
    if (index == 0) return const Color(0xffE9A323);
    return const Color(0xff6387B4);
  }
}
