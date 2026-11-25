
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_small_circle_button.dart';

import '../../components/custom_scaffold.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isAllRead = false;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  @override
  void initState() {
    super.initState();

    _messageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          final notification = message.notification;

          if (notification == null || !mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? 'New Notification',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(notification.body ?? ''),
                ],
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  final List<Map<String, dynamic>> todayNotifications = [
    {
      "icon": Icons.warning_amber_rounded,
      "iconBg": AppColors.light_red,
      "iconColor": AppColors.red,
      "title": "Thunderstorm warning",
      "description":
      "Storms expected near Jhelum between 11 AM - 1 PM on your saved Lahore to Islamabad trip.",
      "time": "8:42 AM",
    },
    {
      "icon": Icons.auto_awesome_outlined,
      "iconBg": AppColors.soft_blue,
      "iconColor": AppColors.primary,
      "title": "New AI advice is ready",
      "description":
      "Gemini has updated your travel tips for Lahore to Islamabad. Suggested departure: 6:30 AM.",
      "time": "8:40 AM",
    },
    {
      "icon": Icons.access_time,
      "iconBg": AppColors.soft_orange,
      "iconColor": AppColors.orange,
      "title": "Time to get ready",
      "description":
      "Your trip to Islamabad is scheduled for tomorrow at 8:00 AM.",
      "time": "7:30 AM",
    },
  ];

  final List<Map<String, dynamic>> earlierNotifications = [
    {
      "icon": Icons.check_circle_outline,
      "iconBg": AppColors.soft_green,
      "iconColor": AppColors.green,
      "title": "Weather improved",
      "description":
      "Fog has cleared on your Islamabad to Murree route. Conditions are looking better.",
      "time": "Mon",
    },
    {
      "icon": Icons.water_drop_outlined,
      "iconBg": AppColors.soft_blue,
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
        color: showNew
            ? AppColors.pureWhite
            : Colors.transparent,
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

                  CustomSmallCircleButton(
                      isIcon: true,
                      icon: Icons.chevron_left_outlined,
                      iconColor: AppColors.ink,
                      onButtonTap: () {
                        Get.back();
                      }),

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
                  CustomSmallCircleButton(isIcon: true, icon: Icons.settings_outlined, iconColor: AppColors.ink, onButtonTap: () {}),
                ],
              ),

              24.verticalSpace,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(
                  isAllRead ? "You are all caught up" : "3 unread notifications",
                  style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.muted,
                  ),
                ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isAllRead = true;
                      });
                    },
                    child: Text(
                      "Mark all as read",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
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
                          showNew: !isAllRead,
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
