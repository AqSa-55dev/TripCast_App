import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../components/custom_scaffold.dart';
import '../../components/custom_small_circle_button.dart';

class StopForecast extends StatefulWidget {
  const StopForecast({super.key});

  @override
  State<StopForecast> createState() => _StopForecastState();
}

class _StopForecastState extends State<StopForecast> {

  final List<String> hours = ['8 AM', '9 AM', '10 AM', '11 AM', '12 PM', '1 PM', '2 PM', '3 PM'];
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: true,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.w),
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
                  10.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gujrat",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),
                      // 5.verticalSpace,
                      Text(
                        "Stop 3 of 5 · You arrive about 10:30 AM",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              14.verticalSpace,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.transparentBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(color: AppColors.borderBlue,width: 1, style: BorderStyle.solid)
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "19°",
                          style: TextStyle(
                            fontSize: 56.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                            "Light rain",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          "Feels like 18° · High 21° · Low 17°",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Image.asset(AppAssets.cloudRainIcon,scale: 2,
                        ),
                    ),

                  ],
                ),
              ),
              16.verticalSpace,
              Text(
                "Hour by hour",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// Hourly forecast card
class HourlyForecastCard extends StatelessWidget {

  final String time;
  final String temperature;
  final String rain;
  final String wind;

  const HourlyForecastCard({
    super.key,
    required this.time,
    required this.temperature,
    required this.rain,
    required this.wind,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68.w,
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.borderBlue,
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // hour
          Text(
            time,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),

          // Weather icon
          Image.asset(
            AppAssets.cloudIcon,
            height: 32.h,
            width: 32.w,
          ),

          // Temperature
          Text(
            temperature,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),

          // Rain probability
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: 13.sp,
                color: AppColors.primary,
              ),
              3.horizontalSpace,
              Text(
                rain,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),

          // Wind speed
          Text(
            wind,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
