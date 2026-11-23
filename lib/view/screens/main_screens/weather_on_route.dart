
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_button.dart';
import 'package:trip_cast/view/components/custom_scaffold.dart';
import '../../components/custom_small_circle_button.dart';
import '../../components/weather_stop_card.dart';

class WeatherOnRoute extends StatefulWidget {
  const WeatherOnRoute({super.key});

  @override
  State<WeatherOnRoute> createState() => _WeatherOnRouteState();
}

class _WeatherOnRouteState extends State<WeatherOnRoute> {

  final List<String> rainPercentages = [
    '5%',
    '15%',
    '45%',
    '70%',
    '80%',
    '40%',
  ];

  final List<String> hours = [
    '8 AM',
    '9 AM',
    '10 AM',
    '11 AM',
    '12 PM',
    '1 PM',
  ];

  final List<double> rainBarHeights = [
    5,
    12,
    35,
    55,
    60,
    30,
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: true,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Screen heading
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

                // Journey summary
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
                        color: AppColors.primary.withOpacity(0.18),
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
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

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          rainPercentages.length,
                              (index) {
                            return Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    rainPercentages[index],
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  8.verticalSpace,

                                  Container(
                                    height: 78.h,
                                    width: 40.w,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius:
                                      BorderRadius.circular(12.r),
                                    ),
                                    child: Container(
                                      height: rainBarHeights[index].h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: index >= 3
                                            ? AppColors.primary
                                            : AppColors.soft_blue,
                                        borderRadius:
                                        BorderRadius.circular(12.r),
                                      ),
                                    ),
                                  ),

                                  8.verticalSpace,

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

                // Stops heading
                Text(
                  'Stops along the way',
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),

                14.verticalSpace,

                // Lahore weather
                const WeatherStopCard(
                  cityName: 'Lahore',
                  condition: 'Sunny',
                  time: '8:00 AM',
                  temperature: '24°',
                  rain: '5%',
                  humidity: '48%',
                  wind: '9 km/h',
                  weatherIcon: Icons.wb_sunny_rounded,
                  cardColor: Color(0xffFFF8DF),
                  iconColor: Color(0xffE9A323),
                ),

                14.verticalSpace,

                // Gujranwala weather
                const WeatherStopCard(
                  cityName: 'Gujranwala',
                  condition: 'Partly cloudy',
                  time: '9:15 AM',
                  temperature: '22°',
                  rain: '20%',
                  humidity: '55%',
                  wind: '12 km/h',
                  weatherIcon: Icons.wb_cloudy_rounded,
                  cardColor: Color(0xffF0F4FA),
                  iconColor: Color(0xff6387B4),
                ),

                14.verticalSpace,

                // Gujrat weather
                WeatherStopCard(
                  cityName: 'Gujrat',
                  condition: 'Light rain',
                  time: '10:30 AM',
                  temperature: '19°',
                  rain: '60%',
                  humidity: '78%',
                  wind: '15 km/h',
                  weatherIcon: Icons.cloudy_snowing,
                  cardColor: const Color(0xffE4EFFF),
                  iconColor: AppColors.primary,
                ),

                24.verticalSpace,

                // AI recommendations button
                Custombutton(
                  buttonText: '✧  View AI recommendations',
                  buttonColor: AppColors.primary,
                  TextColor: AppColors.pureWhite,
                  showBoxShadow: true,
                ),

                15.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
