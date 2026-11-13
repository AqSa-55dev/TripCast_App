
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/utils/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgotPasswordScreen> {

  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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

              15.verticalSpace,

              Container(
                padding: EdgeInsets.all(15),
                height: 72.h,
                width: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/icons/Gmail.png",
                    scale: 2,
                  ),
                ),
              ),

              25.verticalSpace,

              Text(
                "Forgot your password?",
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),

              12.verticalSpace,

              Text(
                "Enter the email you signed up with. We will send "
                    "you a link to choose a new password.",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),

              28.verticalSpace,

              Text(
                "Email",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),

              10.verticalSpace,

              Container(
                height: 54.h,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    hintText: "you@example.com",
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.muted,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              25.verticalSpace,

              Container(
                height: 56.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: Text(
                    "Send reset link",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.pureWhite,
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
