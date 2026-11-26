// Screen 14: Stop Forecast Detail Screen
// Clean, simple & beginner-friendly MVC View
// Location: lib/view/screens/main_screens/stop_forecast.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/weather_model.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../components/custom_button.dart';
import '../../components/custom_scaffold.dart';
import '../../components/custom_small_circle_button.dart';

class StopForecast extends StatelessWidget {
  final String stopName;
  final int stopIndex;
  final int totalStops;
  final String arrivalTime;
  final WeatherModel weatherModel;
  final DateTime departureDateTime;

  const StopForecast({
    super.key,
    required this.stopName,
    required this.stopIndex,
    required this.totalStops,
    required this.arrivalTime,
    required this.weatherModel,
    required this.departureDateTime,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Current Weather Data (seedhe variables)
    final int currentTemp = weatherModel.current?.temperature2M?.round() ?? 20;
    final int humidity = weatherModel.current?.relativeHumidity2M ?? 50;
    final int windSpeed = weatherModel.current?.windSpeed10M?.round() ?? 10;
    final int weatherCode = weatherModel.current?.weatherCode ?? 0;

    // High aur Low simple calculation
    final int highTemp = currentTemp + 2;
    final int lowTemp = currentTemp - 3;
    final int feelsLike = currentTemp - 1;

    // Condition text aur image (bilkul simple if/else)
    String condition = "Sunny";
    String weatherIconAsset = AppAssets.sunIcon;

    if (weatherCode >= 51) {
      condition = "Light rain";
      weatherIconAsset = AppAssets.cloudRainIcon;
    } else if (weatherCode >= 1 && weatherCode <= 3) {
      condition = "Partly cloudy";
      weatherIconAsset = AppAssets.partlyCloudyIcon;
    } else if (weatherCode == 45 || weatherCode == 48) {
      condition = "Foggy";
      weatherIconAsset = AppAssets.cloudIcon;
    }

    // Rain chance from hourly list (agar available ho)
    int rainChance = 0;
    if (weatherModel.hourly?.precipitationProbability != null &&
        weatherModel.hourly!.precipitationProbability!.isNotEmpty) {
      rainChance = weatherModel.hourly!.precipitationProbability!.first;
    }

    return CustomScaffold(
      isBackgroundGradient: true,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomSmallCircleButton(
                    isIcon: true,
                    icon: Icons.arrow_back_ios_new_outlined,
                    iconColor: AppColors.ink,
                    onButtonTap: () => Get.back(),
                  ),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stopName,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        "Stop $stopIndex of $totalStops · You arrive about $arrivalTime",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              18.verticalSpace,

              // Main Weather Card
              _buildMainCard(
                temp: currentTemp,
                condition: condition,
                feelsLike: feelsLike,
                high: highTemp,
                low: lowTemp,
                iconAsset: weatherIconAsset,
              ),

              22.verticalSpace,

              // "Hour by hour" Title
              Text(
                "Hour by hour",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),

              14.verticalSpace,

              // Hourly Horizontal Cards List
              _buildHourlyList(currentTemp, weatherIconAsset),

              24.verticalSpace,

              // "Conditions" Title
              Text(
                "Conditions",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),

              14.verticalSpace,

              // Conditions 2x3 Grid (Rain, Humidity, Wind, UV, Visibility, Sunset)
              _buildConditionsGrid(rainChance, humidity, windSpeed),

              28.verticalSpace,

              // Bottom Button "Back to all stops"
              Custombutton(
                buttonText: "Back to all stops",
                buttonColor: AppColors.pureWhite,
                TextColor: AppColors.primary,
                BorderColor: AppColors.primary,
                onButtonTap: () => Get.back(),
              ),

              16.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  // 2. Main Big Weather Card
  Widget _buildMainCard({
    required int temp,
    required String condition,
    required int feelsLike,
    required int high,
    required int low,
    required String iconAsset,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primarySoft_grey.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: AppColors.borderBlue, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$temp°",
                style: TextStyle(
                  fontSize: 54.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                  height: 1.0,
                ),
              ),
              8.verticalSpace,
              Text(
                condition,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              4.verticalSpace,
              Text(
                "Feels like $feelsLike° · High $high° · Low $low°",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Image.asset(iconAsset, height: 75.h, width: 75.w),
        ],
      ),
    );
  }

  // 3. Hourly Horizontal List (Next 6 Hours)
  Widget _buildHourlyList(int baseTemp, String iconAsset) {
    return SizedBox(
      height: 155.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 6,
        // 6 ghante show karenge
        separatorBuilder: (context, index) => 10.horizontalSpace,
        itemBuilder: (context, index) {
          // Time label: e.g. 8 AM, 9 AM, 10 AM...
          final DateTime time = departureDateTime.add(Duration(hours: index));
          final String hourText = DateFormat('h a').format(time);

          // 2nd card ko highlight karenge (Arrival hour matching Figma)
          final bool isHighlighted = (index == 2);

          // Hourly temperature & rain from model (agar available ho)
          int hourTemp = baseTemp;
          int hourRain = 10;

          if (weatherModel.hourly?.temperature2M != null &&
              index < weatherModel.hourly!.temperature2M!.length) {
            hourTemp = weatherModel.hourly!.temperature2M![index].round();
          }

          if (weatherModel.hourly?.precipitationProbability != null &&
              index < weatherModel.hourly!.precipitationProbability!.length) {
            hourRain = weatherModel.hourly!.precipitationProbability![index];
          }

          return Container(
            width: 95.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isHighlighted ? AppColors.primary : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: isHighlighted
                    ? AppColors.primary
                    : AppColors.border_grey.withValues(alpha: 0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isHighlighted
                      ? AppColors.primary.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hourText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isHighlighted ? AppColors.pureWhite : AppColors.ink,
                  ),
                ),
                Image.asset(iconAsset, height: 30.h, width: 30.w),
                Text(
                  "$hourTemp°",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: isHighlighted ? AppColors.pureWhite : AppColors.ink,
                  ),
                ),
                Text(
                  "$hourRain%",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isHighlighted
                        ? AppColors.pureWhite.withValues(alpha: 0.85)
                        : AppColors.muted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 4. Conditions 2x3 Grid
  Widget _buildConditionsGrid(int rain, int humidity, int wind) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTile("Chance of rain", "$rain%")),
            12.horizontalSpace,
            Expanded(child: _buildTile("Humidity", "$humidity%")),
          ],
        ),
        12.verticalSpace,
        Row(
          children: [
            Expanded(child: _buildTile("Wind", "$wind km/h")),
            12.horizontalSpace,
            Expanded(child: _buildTile("UV index", "2")),
          ],
        ),
        12.verticalSpace,
        Row(
          children: [
            Expanded(child: _buildTile("Visibility", "10 km")),
            12.horizontalSpace,
            Expanded(child: _buildTile("Sunset", "5:18 PM")),
          ],
        ),
      ],
    );
  }

  // Chota Single Condition Card Tile
  Widget _buildTile(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          6.verticalSpace,
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
