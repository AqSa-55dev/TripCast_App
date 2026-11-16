
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/utils/app_colors.dart';

class CheckYourEmail extends StatelessWidget {
  const CheckYourEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Center(
                    child: Icon(
                      Icons.chevron_left,
                      color: AppColors.ink,
                      size: 25,
                    ),
                  ),
                ),
              ),

              38.verticalSpace,

              Center(
                child: Container(
                  height: 56.h,
                  width: 56.w,
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: AppColors.green,
                      size: 30,
                    ),
                  ),
                ),
              ),

              10.verticalSpace,

              Center(
                child: Text(
                  "Check your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
              ),

              8.verticalSpace,

              Center(
                child: Text(
                  "We sent a reset link. It may take a minute "
                      "to arrive, so check your spam folder too.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.muted,
                    height: 1.5,
                  ),
                ),
              ),

              16.verticalSpace,

              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(30.r),
                child: Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      "Back to login",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
