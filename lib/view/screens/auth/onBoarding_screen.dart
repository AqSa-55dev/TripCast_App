
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:trip_cast/utils/app_assets.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_button.dart';
import 'package:trip_cast/view/screens/auth/login_signup_screen.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPageIndex = 0;
  final PageController pageViewController= PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: pageViewController,
                onPageChanged: (index){currentPageIndex=index; setState(() {

                });},
                children: [
                  SingleChildScrollView(
                    child: SafeArea(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Column(//mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 5,
                            children: [
                            Container(width: 350.w,height: 400.h,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.r),
                              image: DecorationImage(image: AssetImage(AppAssets.OnboardingStep1), fit: BoxFit.fill)
                                    ,boxShadow: [
                                    BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12), // Light, subtle shadow
                              blurRadius: 12, // Softness of the shadow
                              spreadRadius: 1, // How far the shadow extends
                              offset: const Offset(0, 4), // Moves shadow 4px down
                            ),
                                    ],
                                    ),
                                ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Row(spacing: 3, mainAxisAlignment: MainAxisAlignment.center,
                               children: [currentPageIndex==0?Image.asset(AppAssets.DashIcon, scale: 2,):Icon(Icons.circle, color: AppColors.soft_blue,size: 8,),
                                 currentPageIndex==1?Image.asset(AppAssets.DashIcon, scale: 2,):Icon(Icons.circle, color: AppColors.soft_blue,size: 8,),
                                 currentPageIndex==2?Image.asset(AppAssets.DashIcon, scale: 2,):Icon(Icons.circle, color: AppColors.soft_blue,size: 8,)],
                             ),
                           ),
                           
                           Text("Plan trips around the weather", textAlign: TextAlign.center,style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight(900), color: AppColors.ink, ),),

                            Text("Enter where you are going and when. TripCast does the rest.", textAlign: TextAlign.center,style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight(500), color: AppColors.muted_grey),),

                              50.verticalSpace,
                              Custombutton(buttonText: "Next", buttonColor: AppColors.primary, TextColor: AppColors.pureWhite, showBoxShadow: true,
                                onButtonTap: () {
                                  pageViewController.jumpToPage(currentPageIndex+1);
                                },),
                              10.verticalSpace,
                              InkWell(onTap: (){Get.to(() => LoginSignupScreen());},child: Text("Skip", style: TextStyle(fontSize: 14, fontWeight: FontWeight(600), color: AppColors.muted_grey)))
                          ],),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: SafeArea(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Column(//mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Container(width: 350.w,height: 400.h,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.r),
                                  image: DecorationImage(image: AssetImage(AppAssets.OnboardingStep2), fit: BoxFit.fill)
                                  ,boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.12), // Light, subtle shadow
                                      blurRadius: 12, // Softness of the shadow
                                      spreadRadius: 1, // How far the shadow extends
                                      offset: const Offset(0, 4), // Moves shadow 4px down
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(spacing: 3, mainAxisAlignment: MainAxisAlignment.center,
                                  children: [currentPageIndex==0?Image.asset(AppAssets.DashIcon, scale: 2,):Icon(Icons.circle, color: AppColors.soft_blue,size: 8,),
                                    currentPageIndex==1?Image.asset(AppAssets.DashIcon, scale: 2,):Icon(Icons.circle, color: AppColors.soft_blue,size: 8,),
                                    currentPageIndex==2?Image.asset(AppAssets.DashIcon, scale: 2,):Icon(Icons.circle, color: AppColors.soft_blue,size: 8,)],
                                ),
                              ),

                              Text("See the weather on every mile", textAlign: TextAlign.center,style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight(900), color: AppColors.ink, ),),

                              Text("Weather icons appear along your route, so you can spot rain, heat or wind before you set off.", textAlign: TextAlign.center,style: TextStyle(fontSize: 15, fontWeight: FontWeight(500), color: AppColors.muted_grey),),

                              50.verticalSpace,
                              Custombutton(buttonText: "Next", buttonColor: AppColors.primary, TextColor: AppColors.pureWhite, showBoxShadow: true,
                                onButtonTap: () {
                                  pageViewController.jumpToPage(currentPageIndex+1);
                                },),
                              10.verticalSpace,
                              InkWell(onTap: (){Get.to(() => LoginSignupScreen());},child: Text("Skip", style: TextStyle(fontSize: 14, fontWeight: FontWeight(600), color: AppColors.muted_grey)))
                            ],),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: SafeArea(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Column(//mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Container(width: 350.w,height: 400.h,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.r),
                                  image: DecorationImage(image: AssetImage(AppAssets.OnboardingStep3), fit: BoxFit.fill)
                                  ,boxShadow: [
                                    BoxShadow(
                                      color: AppColors.soft_blue.withValues(alpha: 0.12), // Light, subtle shadow
                                      blurRadius: 12, // Softness of the shadow
                                      spreadRadius: 1, // How far the shadow extends
                                      offset: const Offset(0, 4), // Moves shadow 4px down
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(spacing: 3, mainAxisAlignment: MainAxisAlignment.center,
                                  children: [currentPageIndex==0?Image.asset(AppAssets.DashIcon, scale: 2,):Icon(Icons.circle, color: AppColors.soft_blue,size: 8,),
                                    currentPageIndex==1?Image.asset(AppAssets.DashIcon, scale: 2,):Icon(Icons.circle, color: AppColors.soft_blue,size: 8,),
                                    currentPageIndex==2?Image.asset(AppAssets.DashIcon, scale: 2,):Icon(Icons.circle, color: AppColors.soft_blue,size: 8,)],
                                ),
                              ),

                              Text("Get clear advice from AI", textAlign: TextAlign.center,style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight(900), color: AppColors.ink, ),),

                              Text("Gemini reads the forecast and tells you when to leave, what to wear and what to watch for. No chatting needed.", textAlign: TextAlign.center,style: TextStyle(fontSize: 15, fontWeight: FontWeight(500), color: AppColors.muted_grey),),

                              50.verticalSpace,
                              Custombutton(buttonText: "Get Started", buttonColor: AppColors.primary, TextColor: AppColors.pureWhite, showBoxShadow: true,
                                onButtonTap: () {
                                  Get.to(() => LoginSignupScreen());
                                },),
                              10.verticalSpace,
                              InkWell(onTap: (){pageViewController.jumpToPage(currentPageIndex-1);},
                                  child: Text("Back", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight(600), color: AppColors.muted_grey)))
                            ],),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
