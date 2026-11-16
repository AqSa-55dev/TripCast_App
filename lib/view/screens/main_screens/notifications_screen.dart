import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/view/components/custom_scaffold.dart';

import '../../../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isBackgroundGradient: true,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.chevron_left_outlined,
                        color: AppColors.ink,
                        size: 25,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              )
            ],
        ),
      ),
    ),);
  }
}
