
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/utils/app_colors.dart';

class WeatherStopCard extends StatelessWidget {
  final String cityName;
  final String condition;
  final String time;
  final String temperature;
  final String rain;
  final String humidity;
  final String wind;
  final IconData weatherIcon;
  final Color cardColor;
  final Color iconColor;

  const WeatherStopCard({
    super.key,
    required this.cityName,
    required this.condition,
    required this.time,
    required this.temperature,
    required this.rain,
    required this.humidity,
    required this.wind,
    required this.weatherIcon,
    required this.cardColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.border_grey,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 58.h,
                width: 58.w,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(
                  weatherIcon,
                  color: iconColor,
                  size: 32.sp,
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
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
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
                  fontSize: 29.sp,
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
          color: AppColors.pureWhite.withOpacity(0.85),
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
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
