
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/utils/app_assets.dart';

class WeatherStopCard extends StatelessWidget {
  final String cityName;
  final String condition;
  final String time;
  final String temperature;
  final String rain;
  final String humidity;
  final String wind;
  final String weatherIconAsset;
  final Color cardColor;
  final Color iconColor;
  final Color? borderColor;

  const WeatherStopCard({
    super.key,
    required this.cityName,
    required this.condition,
    required this.time,
    required this.temperature,
    required this.rain,
    required this.humidity,
    required this.wind,
    required this.weatherIconAsset,
    required this.cardColor,
    required this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: borderColor ?? AppColors.border_grey,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 52.h,
                width: 52.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Image.asset(
                  weatherIconAsset,
                  height: 32.h,
                  width: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    3.verticalSpace,
                    Text(
                      '$condition · $time',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                temperature,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          14.verticalSpace,
          Row(
            children: [
              _weatherDetail('Rain', rain),
              8.horizontalSpace,
              _weatherDetail('Humidity', humidity),
              8.horizontalSpace,
              _weatherDetail('Wind', wind),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weatherDetail(String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.pureWhite.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.muted,
              ),
            ),
            3.verticalSpace,
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
