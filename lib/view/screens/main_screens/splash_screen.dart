import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:trip_cast/view/screens/auth/login_signup_screen.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import 'bottom_nav_screens/bottom_nav_home.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

  //  String accessToken =LocalStorage.getData(key: LocalStorageKeys.accessToken);
  //   _timer = Timer(
  //       const Duration(milliseconds: 2500),
  //           () {
  //         if (accessToken=="") {
  //           Get.offAll(() =>  LoginSignupScreen());}
  //         else{
  //           Get.offAll(() =>  BottomNavHome());}
  //       });
  }

  @override
  void dispose() {
    _timer?.cancel();
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.splashBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 150.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 112.h,
                    width: 112.w,
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(32.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pureWhite.withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        )
                      ]
                    ),
                    child: Center(
                      child: Image.asset(
                        AppAssets.splashIcon,
                        scale: 2,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Text(
                    "TripCast",
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pureWhite,
                    ),
                  ),

                  8.verticalSpace,
                  Text(
                    "Know the weather before you go",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.pureWhite,
                    ),
                  ),
                ],

              ),
            ),



          ]
        ),
      )
    );
  }
}
