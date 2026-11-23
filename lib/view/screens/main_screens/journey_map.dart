import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_button.dart';
import 'package:trip_cast/view/components/custom_status_badge.dart';
import 'package:trip_cast/view/screens/main_screens/route_weather_screen.dart';

import '../../components/custom_small_circle_button.dart';


class JourneyMap extends StatefulWidget {
  const JourneyMap({super.key});

  @override
  State<JourneyMap> createState() => _JourneyMapState();
}

class _JourneyMapState extends State<JourneyMap> {
  MapboxMap? mapboxMapController;





    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [

            // 1. Full-screen Mapbox
            Positioned.fill(
              child: MapWidget(
                onMapCreated: _onMapCreated,
              ),
            ),
            Positioned(top: 25,
                left: 20,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,spacing: 10,
              children: [
              CustomSmallCircleButton(isIcon: true, icon: Icons.arrow_back_ios_new_outlined,iconColor: AppColors.ink,onButtonTap: (){Get.back();},),
              Container(padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(22.r),boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12), // Light, subtle shadow
                    blurRadius: 12, // Softness of the shadow
                    spreadRadius: 1, // How far the shadow extends
                    offset: const Offset(0, 4), // Moves shadow 4px down
                  ),
                ],
                ),
                child: Text("Lahore to Islamabad",style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),),),
              CustomSmallCircleButton(isIcon: true, icon: Icons.favorite_border_outlined,iconColor: AppColors.primary,),


            ],)),

            // 2. Bottom sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,

              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.30,
                minChildSize: 0.20,
                maxChildSize: 0.50,

                builder: (context, scrollController) {
                  return Container(
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.r),
                      ),
                    ),

                    child: SingleChildScrollView(
                      controller: scrollController,

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                        ),

                        child: Column(
                          children: [

                            10.verticalSpace,

                            // Drag handle
                            Container(
                              margin: EdgeInsets.all(8),
                              height: 5.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),

                            15.verticalSpace,

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column( crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Text(
                                      "Lahore to Islamabad",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.ink,
                                      ),
                                    ),

                                    Text(
                                      "Thu 12 Nov . Depart 8:00 AM",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.muted_grey,
                                      ),
                                    ),
                                  ],
                                ),
                                CustomStatusBadge()
                              ],
                            ),

                            SizedBox(height: 15.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              spacing:10,
                              children: [
                                ShortDetailCard("Distance", "380 km"),
                                ShortDetailCard("Duration", "4h 45m"),
                                ShortDetailCard("Weather points", "5"),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            Custombutton(
                              buttonText: "Weather Details",
                              buttonColor: AppColors.pureWhite,
                              TextColor: AppColors.primary,
                              BorderColor: AppColors.primary,
                              onButtonTap: () {
                                Get.to(() => const RouteWeatherScreen());
                              },
                            ),
                            10.verticalSpace,
                            Custombutton(
                              buttonText: "AI Recommendations",
                              buttonColor: AppColors.primary,
                              TextColor: AppColors.pureWhite,
                              showBoxShadow: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }


  void _onMapCreated(MapboxMap controller){
    setState(() {
      mapboxMapController=controller;
    });
    mapboxMapController?.location.updateSettings(LocationComponentSettings(enabled: true));
    
  }

}

Widget ShortDetailCard(String Heading, String Value){
  return Container(

    // width: 110.w,
    //height: 50.h,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(color: AppColors.veryLightBlue,borderRadius: BorderRadius.circular(15.r)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,spacing: 4,
      children: [

          Text(Heading,style: TextStyle(color: AppColors.muted_grey, fontSize: 11.sp, fontWeight: FontWeight(700)), ),
        Text(Value,style: TextStyle(color: AppColors.ink, fontSize: 13.sp, fontWeight: FontWeight(900)), ),

      ],
    ),

  );
}