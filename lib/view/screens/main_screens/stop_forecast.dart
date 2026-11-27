
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

  // Convert the arrival time string into the actual arrival DateTime.
  DateTime _getArrivalDateTime() {
    final parsedTime = DateFormat('h:mm a').parse(arrivalTime);

    DateTime result = DateTime(
      departureDateTime.year,
      departureDateTime.month,
      departureDateTime.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    if (result.isBefore(departureDateTime)) {
      result = result.add(const Duration(days: 1));
    }

    return result;
  }

  // Find an hourly forecast by matching its local date and hour.
  int _findHourlyIndex(DateTime targetTime) {
    final times = weatherModel.hourly?.time ?? [];

    final String target = DateFormat('yyyy-MM-ddTHH').format(targetTime);

    for (int i = 0; i < times.length; i++) {
      if (times[i].startsWith(target)) {
        return i;
      }
    }

    return -1;
  }

  // Find the daily forecast for the selected date.
  int _findDailyIndex(DateTime targetDate) {
    final dates = weatherModel.daily?.time ?? [];
    final String target = DateFormat('yyyy-MM-dd').format(targetDate);

    for (int i = 0; i < dates.length; i++) {
      if (dates[i] == target) {
        return i;
      }
    }

    return -1;
  }

  // Weather condition and icon for a weather code.
  String _getCondition(int code) {
    if (code == 0) return 'Clear';
    if (code == 1) return 'Mainly clear';
    if (code == 2) return 'Partly cloudy';
    if (code == 3) return 'Cloudy';

    if (code == 45 || code == 48) return 'Foggy';

    if (code >= 51 && code <= 57) return 'Drizzle';

    if (code >= 61 && code <= 65) return 'Rain';

    if (code == 66 || code == 67) return 'Freezing rain';

    if (code >= 71 && code <= 77) return 'Snow';

    if (code >= 80 && code <= 82) return 'Rain showers';

    if (code == 85 || code == 86) return 'Snow showers';

    if (code >= 95) return 'Thunderstorm';

    return 'Forecast unavailable';
  }

  String _getWeatherIcon(int code) {
    if (code == 0) return AppAssets.sunIcon;

    if (code == 1 || code == 2) {
      return AppAssets.partlyCloudyIcon;
    }

    if (code == 3 || code == 45 || code == 48) {
      return AppAssets.cloudIcon;
    }

    if (code >= 51) return AppAssets.cloudRainIcon;

    return AppAssets.cloudIcon;
  }

  // Safely read a value from an hourly list.
  String _hourlyValue(
      List<dynamic>? values,
      int index,
      String suffix,
      ) {
    if (index < 0 || values == null || index >= values.length) {
      return '--';
    }

    return '${values[index]}$suffix';
  }

  // Safely read a daily temperature.
  String _dailyTemperature(List<double>? values, int index) {
    if (index < 0 || values == null || index >= values.length) {
      return '--';
    }

    return '${values[index].round()}°';
  }

  // Format sunset time.
  String _getSunset(int dailyIndex) {
    final sunsetList = weatherModel.daily?.sunset ?? [];

    if (dailyIndex < 0 || dailyIndex >= sunsetList.length) {
      return '--';
    }

    try {
      return DateFormat('h:mm a').format(
        DateTime.parse(sunsetList[dailyIndex]),
      );
    } catch (e) {
      return '--';
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime arrivalDateTime = _getArrivalDateTime();

    final int arrivalHourIndex = _findHourlyIndex(arrivalDateTime);
    final int dailyIndex = _findDailyIndex(arrivalDateTime);

    final hourly = weatherModel.hourly;
    final daily = weatherModel.daily;

    final int weatherCode =
    arrivalHourIndex >= 0 &&
        hourly?.weatherCode != null &&
        arrivalHourIndex < hourly!.weatherCode!.length
        ? hourly.weatherCode![arrivalHourIndex]
        : -1;

    final String condition = _getCondition(weatherCode);
    final String weatherIcon = _getWeatherIcon(weatherCode);

    final String temperature = _hourlyValue(
      hourly?.temperature2M,
      arrivalHourIndex,
      '°',
    );

    final String feelsLike = _hourlyValue(
      hourly?.apparentTemperature,
      arrivalHourIndex,
      '°',
    );

    final String highTemperature = _dailyTemperature(
      daily?.temperature2MMax,
      dailyIndex,
    );

    final String lowTemperature = _dailyTemperature(
      daily?.temperature2MMin,
      dailyIndex,
    );

    final String rainChance = _hourlyValue(
      hourly?.precipitationProbability,
      arrivalHourIndex,
      '%',
    );

    final String humidity = _hourlyValue(
      hourly?.relativeHumidity2M,
      arrivalHourIndex,
      '%',
    );

    final String wind = _hourlyValue(
      hourly?.windSpeed10M,
      arrivalHourIndex,
      ' km/h',
    );

    final String uvIndex = _hourlyValue(
      hourly?.uvIndex,
      arrivalHourIndex,
      '',
    );

    String visibility = '--';

    if (arrivalHourIndex >= 0 &&
        hourly?.visibility != null &&
        arrivalHourIndex < hourly!.visibility!.length) {
      final double visibilityKm =
          hourly.visibility![arrivalHourIndex] / 1000;

      visibility = '${visibilityKm.toStringAsFixed(1)} km';
    }

    final String sunset = _getSunset(dailyIndex);

    return CustomScaffold(
      isBackgroundGradient: true,
      bottomNavigationBar: BottomAppBar(
        height: 90.h,
        color: AppColors.pureWhite,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
          child: Custombutton(
            buttonText: 'Back to all stops',
            buttonColor: AppColors.pureWhite,
            TextColor: AppColors.primary,
            BorderColor: AppColors.primary,
            borderRadius: BorderRadius.circular(26.r),
            onButtonTap: () => Get.back(),
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top heading
              Row(
                children: [
                  CustomSmallCircleButton(
                    isIcon: true,
                    icon: Icons.arrow_back_ios_new_outlined,
                    iconColor: AppColors.ink,
                    onButtonTap: () => Get.back(),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stopName,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          'Stop $stopIndex of $totalStops · You arrive about $arrivalTime',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              18.verticalSpace,

              // Main weather card
              _buildMainCard(
                temperature: temperature,
                condition: condition,
                feelsLike: feelsLike,
                high: highTemperature,
                low: lowTemperature,
                iconAsset: weatherIcon,
              ),

              22.verticalSpace,

              Text(
                'Hour by hour',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),

              14.verticalSpace,

              _buildHourlyList(arrivalDateTime),

              24.verticalSpace,

              Text(
                'Conditions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),

              14.verticalSpace,

              _buildConditionsGrid(
                rain: rainChance,
                humidity: humidity,
                wind: wind,
                uvIndex: uvIndex,
                visibility: visibility,
                sunset: sunset,
              ),

              16.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  // Main weather card
  Widget _buildMainCard({
    required String temperature,
    required String condition,
    required String feelsLike,
    required String high,
    required String low,
    required String iconAsset,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primarySoft_grey.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: AppColors.borderBlue,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  temperature,
                  style: TextStyle(
                    fontSize: 56.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    height: 1,
                  ),
                ),
                8.verticalSpace,
                Text(
                  condition,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                4.verticalSpace,
                Text(
                  'Feels like $feelsLike · High $high · Low $low',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            iconAsset,
            height: 88.h,
            width: 88.w,
              fit: BoxFit.contain
          ),
        ],
      ),
    );
  }

  // Hourly weather cards
  Widget _buildHourlyList(DateTime arrivalDateTime) {
    return SizedBox(
      height: 155.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (context, index) => 10.horizontalSpace,
        itemBuilder: (context, index) {
          // Show two hours before arrival and continue after it.
          final DateTime time = arrivalDateTime.add(
            Duration(hours: index - 2),
          );

          final int hourIndex = _findHourlyIndex(time);

          final bool isHighlighted = index == 2;

          final String hourText = DateFormat('h a').format(time);

          final hourly = weatherModel.hourly;

          final String hourTemperature = _hourlyValue(
            hourly?.temperature2M,
            hourIndex,
            '°',
          );

          final String hourRain = _hourlyValue(
            hourly?.precipitationProbability,
            hourIndex,
            '%',
          );

          final int code = hourIndex >= 0 &&
              hourly?.weatherCode != null &&
              hourIndex < hourly!.weatherCode!.length
              ? hourly.weatherCode![hourIndex]
              : -1;

          final String iconAsset = _getWeatherIcon(code);

          return Container(
            width: 95.w,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? AppColors.primary
                  : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: isHighlighted
                    ? AppColors.primary
                    : AppColors.border_grey.withValues(alpha: 0.4),
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
                    color: isHighlighted
                        ? AppColors.pureWhite
                        : AppColors.ink,
                  ),
                ),
                Image.asset(
                  iconAsset,
                  height: 28.h,
                  width: 28.w,
                  fit: BoxFit.contain,
                ),
                Text(
                  hourTemperature,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: isHighlighted
                        ? AppColors.pureWhite
                        : AppColors.ink,
                  ),
                ),
                Text(
                  hourRain,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isHighlighted
                        ? AppColors.pureWhite
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

  // Conditions grid
  Widget _buildConditionsGrid({
    required String rain,
    required String humidity,
    required String wind,
    required String uvIndex,
    required String visibility,
    required String sunset,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTile('Chance of rain', rain),
            ),
            12.horizontalSpace,
            Expanded(
              child: _buildTile('Humidity', humidity),
            ),
          ],
        ),

        12.verticalSpace,

        Row(
          children: [
            Expanded(
              child: _buildTile('Wind', wind),
            ),
            12.horizontalSpace,
            Expanded(
              child: _buildTile('UV index', uvIndex),
            ),
          ],
        ),

        12.verticalSpace,

        Row(
          children: [
            Expanded(
              child: _buildTile('Visibility', visibility),
            ),
            12.horizontalSpace,
            Expanded(
              child: _buildTile('Sunset', sunset),
            ),
          ],
        ),
      ],
    );
  }

  // Single condition tile
  Widget _buildTile(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 14.h,
      ),
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
              fontSize: 12.sp,
              color: AppColors.muted,
            ),
          ),
          6.verticalSpace,
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
