
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/utils/app_colors.dart';

import '../../components/custom_scaffold.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final List<Map<String, dynamic>> todayNotifications = [
    {
      "icon": Icons.warning_amber_rounded,
      "iconBg": Color(0xffFFE8E5),
      "iconColor": Color(0xffE64B42),
      "title": "Thunderstorm warning",
      "description":
      "Storms expected near Jhelum between 11 AM - 1 PM on your saved Lahore to Islamabad trip.",
      "time": "8:42 AM",
    },
    {
      "icon": Icons.auto_awesome_outlined,
      "iconBg": AppColors.pureWhite,
      "iconColor": AppColors.primary,
      "title": "New AI advice is ready",
      "description":
      "Gemini has updated your travel tips for Lahore to Islamabad. Suggested departure: 6:30 AM.",
      "time": "8:40 AM",
    },
    {
      "icon": Icons.access_time,
      "iconBg": Color(0xffFFF0D1),
      "iconColor": Color(0xffC47A00),
      "title": "Time to get ready",
      "description":
      "Your trip to Islamabad is scheduled for tomorrow at 8:00 AM.",
      "time": "7:30 AM",
    },
  ];

  final List<Map<String, dynamic>> earlierNotifications = [
    {
      "icon": Icons.wb_sunny_outlined,
      "iconBg": AppColors.pureWhite,
      "iconColor": AppColors.green,
      "title": "Weather improved",
      "description":
      "Fog has cleared on your Islamabad to Murree route. Conditions are looking better.",
      "time": "Mon",
    },
    {
      "icon": Icons.water_drop_outlined,
      "iconBg": AppColors.pureWhite,
      "iconColor": AppColors.primary,
      "title": "Rain on your route",
      "description":
      "Light rain is expected near Hyderabad on your saved Karachi trip.",
      "time": "Fri",
    },
  ];


  Widget notificationCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
    bool showNew = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44.h,
            width: 44.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 23.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
                6.verticalSpace,
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                ),
                if (showNew) ...[
                  8.verticalSpace,
                  Row(
                    children: [
                      Container(
                        height: 6.h,
                        width: 6.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      5.horizontalSpace,
                      Text(
                        "New",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(isBackgroundGradient: true,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              12.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(30.r),
                    child: Container(
                      height: 44.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: AppColors.ink,
                        size: 21.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(30.r),
                    child: Container(
                      height: 44.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: AppColors.ink,
                        size: 21.sp,
                      ),
                    ),
                  ),
                ],
              ),

              24.verticalSpace,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "3 unread notifications",
                    style: TextStyle(
                      color: AppColors.muted_grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Mark all as read",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              22.verticalSpace,

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                        color: AppColors.muted_grey,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    12.verticalSpace,

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: todayNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = todayNotifications[index];
                        return notificationCard(
                          icon: notification["icon"],
                          iconBg: notification["iconBg"],
                          iconColor: notification["iconColor"],
                          title: notification["title"],
                          description: notification["description"],
                          time: notification["time"],
                          showNew: true,
                        );
                      },
                    ),

                    12.verticalSpace,

                    // Earlier Section
                    Text(
                      "Earlier",
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    12.verticalSpace,

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: earlierNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = earlierNotifications[index];
                        return notificationCard(
                          icon: notification["icon"],
                          iconBg: notification["iconBg"],
                          iconColor: notification["iconColor"],
                          title: notification["title"],
                          description: notification["description"],
                          time: notification["time"],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
