import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:trip_cast/utils/app_assets.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_button.dart';
import 'package:trip_cast/view/components/custom_text_field.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {

  int isLogin=0;
  int selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:  EdgeInsets.only(top: 10, bottom: 10),
                  child: Row( spacing: 5,
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.h,
                        padding: EdgeInsets.all(10.h),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.r), color: AppColors.primary ),
                        child: Image.asset(AppAssets.locationIcon, scale: 2,),
                      ),
                      Text("TripCast", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight(900), color: AppColors.ink),)
                    ],
                  ),
                ),

                isLogin == 0?
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome back", style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight(900), color: AppColors.ink),),
                    Text("Log in to plan your next journey around the weather.", style: TextStyle(fontSize: 15.sp, color: AppColors.muted_grey),),
                  ],
                ): Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Create your account", style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight(900), color: AppColors.ink),),
                    Text("Save journeys and get weather advice on any device.", style: TextStyle(fontSize: 15.sp, color: AppColors.muted_grey),),
                  ],
                ),
                10.verticalSpace,
                ToggleButtons(children: [Text("Login"), Text("Signup")],
                  isSelected: [isLogin==1, isLogin==0], borderRadius: BorderRadius.circular(12.r),
                  constraints: const BoxConstraints(
                    minHeight: 44.0,
                    minWidth: 165,
                  ),
                  selectedColor: AppColors.muted_grey,disabledColor: AppColors.muted_grey,textStyle: TextStyle(color:  isLogin==0?AppColors.ink:AppColors.muted_grey, fontWeight: FontWeight(800)),
                  fillColor:AppColors.border_grey, focusColor: AppColors.pureWhite, color: AppColors.ink,
                  onPressed: (selectedIndex) {
                    setState(() {
                      isLogin = selectedIndex ;


                    });
                  },

                ),10.verticalSpace,
                isLogin ==0? Column(spacing: 5, crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Email", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight(900), color: AppColors.ink),),
                    CustomTextField(hintText: "you@example.com"),
                    Text("Password", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight(900), color: AppColors.ink)),
                    CustomTextField(hintText: "Enter your password", isObscure: true,suffixIcon: Icons.remove_red_eye,),
                    Align(alignment: AlignmentGeometry.centerEnd,
                        child: Text("Forgot Password?", style:  TextStyle(fontSize: 14.sp, fontWeight: FontWeight(900), color: AppColors.primary),)),
                    10.verticalSpace,
                    Custombutton(buttonText: "Login", buttonColor: AppColors.primary, TextColor: AppColors.pureWhite),
                    Row(
                      children: [Expanded(
                        child: Divider(
                          height: 5,
                          thickness: 2,
                          indent: 12,
                          endIndent: 15,
                        ),
                      ),
                        Text("or"),

                        Expanded(
                          child: Divider( height: 5,
                            thickness: 2,
                            indent: 12,
                            endIndent: 15,),
                        )],
                    ),
                    Custombutton(buttonText: "Continue with Google", buttonColor: AppColors.pureWhite, TextColor: AppColors.ink),
                  ],
                ): Column(spacing: 5, crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Full name", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight(900), color: AppColors.ink),),
                    CustomTextField(hintText: "Enter your name"),
                    Text("Email", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight(900), color: AppColors.ink),),
                    CustomTextField(hintText: "you@example.com"),
                    Text("Password", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight(900), color: AppColors.ink)),
                    CustomTextField(hintText: "Enter your password", isObscure: true,suffixIcon: Icons.remove_red_eye,),

                    10.verticalSpace,
                    Custombutton(buttonText: "Create account", buttonColor: AppColors.primary, TextColor: AppColors.pureWhite),
                    Row(
                      children: [Expanded(
                        child: Divider(
                          height: 5,
                          thickness: 2,
                          indent: 12,
                          endIndent: 15,
                        ),
                      ),
                        Text("or"),

                        Expanded(
                          child: Divider( height: 5,
                            thickness: 2,
                            indent: 12,
                            endIndent: 15,),
                        )],
                    ),
                    Custombutton(buttonText: "Continue with Google", buttonColor: AppColors.pureWhite, TextColor: AppColors.ink),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
