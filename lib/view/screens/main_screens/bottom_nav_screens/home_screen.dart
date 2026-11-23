import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:trip_cast/utils/app_assets.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_button.dart';
import 'package:trip_cast/view/components/custom_scaffold.dart';
import 'package:trip_cast/view/components/custom_small_circle_button.dart';
import 'package:trip_cast/view/screens/main_screens/bottom_nav_screens/Explore_screen.dart';

import '../notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onExploreTap;
  const HomeScreen({super.key, required this.onExploreTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  @override
  Widget build(BuildContext context) {
    return CustomScaffold(isBackgroundGradient: true,
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Good Morning", style: TextStyle(fontWeight: FontWeight(500), color: AppColors.muted_grey, fontSize: 13),),
                    Text("Hiba",style: TextStyle(fontSize: 24, fontWeight: FontWeight(900), color: AppColors.ink,),),
                  ],),
                  Row(spacing: 5,
                    children: [
                    CustomSmallCircleButton(isIcon: true,icon:
                        Icons.notifications_none_rounded,
                        iconColor: AppColors.ink,
                        size: 25,
                      onButtonTap: (){Get.to(()=>NotificationsScreen());},
                      ),
                    CustomSmallCircleButton(isIcon: false,text: "H",)
      
                  ],),
                ],
              ),
              Container(padding: EdgeInsets.all(10),
                width: double.infinity.w,
                //height: 20.h,
                decoration: BoxDecoration(color: AppColors.primary,borderRadius: BorderRadius.circular(28),boxShadow: [
                BoxShadow(
                color: Colors.black.withValues(alpha: 0.12), // Light, subtle shadow
                blurRadius: 12, // Softness of the shadow
                spreadRadius: 1, // How far the shadow extends
                offset: const Offset(0, 4), // Moves shadow 4px down
              ),
            ],),
                child: Row(spacing: 5,
                children: [Icon(Icons.location_on_outlined, color: AppColors.pureWhite,size: 14,), Text("Lahore · Now",style: TextStyle(fontWeight: FontWeight(600), color: AppColors.pureWhite, fontSize: 13), )]
              ),),
              Container(padding: EdgeInsets.all(15),
                width: double.infinity.w,
                //height: 20.h,
                decoration: BoxDecoration(color: AppColors.pureWhite,borderRadius: BorderRadius.circular(24),boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12), // Light, subtle shadow
                    blurRadius: 12, // Softness of the shadow
                    spreadRadius: 1, // How far the shadow extends
                    offset: const Offset(0, 4), // Moves shadow 4px down
                  ),
                ],),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, spacing:10,
                  children: [
                    Text("Where to next?",style: TextStyle(fontSize: 18, fontWeight: FontWeight(900), color: AppColors.ink,),),
                    Container(padding: EdgeInsets.all(8),
                      width: double.infinity.w,
                      //height: 20.h,
                      decoration: BoxDecoration(color: AppColors.veryLightBlue,borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.sky_grey, width: 1),),
                      child: Row(spacing: 5,
                        children: [
                          Image.asset(AppAssets.StartingLocationIcon, scale: 2,),

                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("From",style: TextStyle(fontSize: 14, fontWeight: FontWeight(600), color: AppColors.muted_grey,),),
                            Text("Lahore",style: TextStyle(fontSize: 16, fontWeight: FontWeight(700), color: AppColors.ink,),)
                          ],
                        )
                      ],),
                    ),
                    Container(padding: EdgeInsets.all(8),
                      width: double.infinity.w,
                      //height: 20.h,
                      decoration: BoxDecoration(color: AppColors.veryLightBlue,borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.sky_grey, width: 1),),
                      child: Row(spacing: 5,
                        children: [
                          Icon(Icons.location_pin, color: AppColors.ink,size: 14,weight: 10,),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("To",style: TextStyle(fontSize: 14, fontWeight: FontWeight(600), color: AppColors.muted_grey,),),
                              Text("Islamabad",style: TextStyle(fontSize: 16, fontWeight: FontWeight(700), color: AppColors.ink,),)
                            ],
                          )
                        ],),
                    ),
                    Custombutton(buttonText: "Plan Journey", buttonColor: AppColors.primary, TextColor: AppColors.pureWhite,showBoxShadow: true,
                    onButtonTap: (){debugPrint("Plan Journey button pressed");
                      widget.onExploreTap();},)
                  ],
                ),
              ),
      
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recent journeys",style: TextStyle(fontSize:18, fontWeight: FontWeight(900), color: AppColors.ink,),),
                  Text("View all",style: TextStyle(fontSize:14, fontWeight: FontWeight(800), color: AppColors.primary,),),
                ],
              ),
              RecentJourneyCard(AppAssets.cloudIcon,"Lahore to Islamabad", "today", "380 km", "Rain near Jhelum"),
              RecentJourneyCard(AppAssets.sunIcon, "Karachi to Hyderabad", "5 Nov", "165 km", "clear skies"),

              Container(
                padding: EdgeInsets.all(15),
                width: double.infinity.w,
                //height: 20.h,
                decoration: BoxDecoration(color: AppColors.primarySoft_grey,borderRadius: BorderRadius.circular(24),boxShadow: [
                  BoxShadow(
                    color: AppColors.soft_blue.withValues(alpha: 0.12), // Light, subtle shadow
                    blurRadius: 12, // Softness of the shadow
                    spreadRadius: 1, // How far the shadow extends
                    offset: const Offset(0, 4), // Moves shadow 4px down
                  ),
                ],),
                child: Row(spacing: 10,mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container( padding: EdgeInsets.all(8),
                      width: 44.w,
                      height: 44.h,
                      decoration:BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
                      child: Image.asset(AppAssets.saveIcon, color: AppColors.pureWhite,scale: 2,),),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Saved Journeys", style: TextStyle(fontSize:15, fontWeight: FontWeight(1000), color: AppColors.ink,),),
                          Text("3 routes to check again", style: TextStyle(fontSize:13, fontWeight: FontWeight(600), color: AppColors.muted_grey,),)],
                      ),
                    ),

                    Icon(Icons.chevron_right, color: AppColors.muted_grey,)
                  ],
                ),
              )
      
            ],
          ),
        ),
      ),
    ),);
  }
}

Widget RecentJourneyCard(String icon,String title,String when, String distance , String weather){
  return Container(
    padding: EdgeInsets.all(15),
    width: double.infinity.w,
    //height: 20.h,
    decoration: BoxDecoration(color: AppColors.pureWhite,borderRadius: BorderRadius.circular(24),boxShadow: [
      BoxShadow(
        color: AppColors.soft_blue.withValues(alpha: 0.12), // Light, subtle shadow
        blurRadius: 12, // Softness of the shadow
        spreadRadius: 1, // How far the shadow extends
        offset: const Offset(0, 4), // Moves shadow 4px down
      ),
    ],),
    child: Row(spacing: 10,crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container( padding: EdgeInsets.all(8),
          width: 44.w,
          height: 44.h,
          decoration:BoxDecoration(color: AppColors.primarySoft_grey, borderRadius: BorderRadius.circular(14)),
          child: Image.asset(icon),),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(title, style: TextStyle(fontSize:15, fontWeight: FontWeight(1000), color: AppColors.ink,),),
            Text("$when . $distance . $weather", style: TextStyle(fontSize:13, fontWeight: FontWeight(600), color: AppColors.muted_grey,),)],
          ),
        ),

        Icon(Icons.chevron_right, color: AppColors.muted_grey,)
      ],
    ),
  );
}