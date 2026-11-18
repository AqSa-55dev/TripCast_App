
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_button.dart';

import '../../components/custom_small_circle_button.dart';

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
              CustomSmallCircleButton(isIcon: true, icon: Icons.arrow_back_ios_new_outlined,iconColor: AppColors.ink,onButtonTap: (){Get.back();},),


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

              Custombutton(buttonText: "Back to Login", buttonColor: AppColors.primary, TextColor: AppColors.pureWhite)

            ],
          ),
        ),
      ),
    );
  }
}
