
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

                  // Chance of rain by Hour
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

                        // Horizontal Scrollable Bars
                        SizedBox(
                          height: 138.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.rainPercentages.length,
                            separatorBuilder: (context, index) =>
                            12.horizontalSpace,
                            itemBuilder: (context, index) {
                              final int rainValue = int.tryParse(controller
                                  .rainPercentages[index]
                                  .replaceAll('%', '')) ??
                                  0;
                              return SizedBox(
                                width: 42.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      controller.rainPercentages[index],
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    8.verticalSpace,

                                    // Capsule bar container
                                    Container(
                                      height: 70.h,
                                      width: 40.w,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius:
                                        BorderRadius.circular(12.r),
                                      ),
                                      child: Container(
                                        height:
                                        controller.rainBarHeights[index].h,
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

                                    8.verticalSpace,

                                    Text(
                                      controller.hours[index],
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

                  // Dynamic Stops along the way list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.weatherStops.length,
                    separatorBuilder: (context, index) => 14.verticalSpace,
                    itemBuilder: (context, index) {
                      final stop = controller.weatherStops[index];
                      return WeatherStopCard(
                        cityName: stop.cityName,
                        condition: stop.condition,
                        time: stop.time,
                        temperature: stop.temperature,
                        rain: stop.rain,
                        humidity: stop.humidity,
                        wind: stop.wind,
                        weatherIcon: stop.weatherIcon,
                        cardColor: stop.cardColor,
                        iconColor: stop.iconColor,
                      );
                    },
                  ),

                  24.verticalSpace,

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
}