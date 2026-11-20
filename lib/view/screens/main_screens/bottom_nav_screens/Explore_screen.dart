import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_scaffold.dart';
import 'package:trip_cast/view/screens/main_screens/choose_location.dart';

import '../../../../controller/date_time_controller.dart';
import '../../../../utils/app_assets.dart';
import '../../../components/custom_button.dart';
import '../date_time_screen.dart';
import '../generating_journey.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  final DateTimeController controller = Get.put(DateTimeController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(isBackgroundGradient: true,
      child: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              Text("Plan your journey", style: TextStyle(color: AppColors.ink,
                  fontSize: 28,
                  fontWeight: FontWeight(900)),),
              Text("Tell us where and when. We check the weather on the way.",
                style: TextStyle(color: AppColors.muted_grey,
                    fontSize: 14,
                    fontWeight: FontWeight(500)),),

              Container(padding: EdgeInsets.all(15),
                width: double.infinity,
                //height: 20.h,
                decoration: BoxDecoration(color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      // Light, subtle shadow
                      blurRadius: 12,
                      // Softness of the shadow
                      spreadRadius: 1,
                      // How far the shadow extends
                      offset: const Offset(0, 4), // Moves shadow 4px down
                    ),
                  ],),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [

                  Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          "Starting Location",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink,
                          ),
                        ),

                        InkWell(onTap: (){Get.to(()=>ChooseLocation());},
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.veryLightBlue,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.sky_grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              spacing: 5,
                              children: [
                                Image.asset(
                                  AppAssets.StartingLocationIcon,
                                  scale: 2,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      "Lahore",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Text(
                          "Destination",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink,
                          ),
                        ),

                        InkWell(onTap: (){Get.to(()=>ChooseLocation());},
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.veryLightBlue,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.sky_grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: AppColors.ink,
                                  size: 14,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      "Islamabad",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Swap Button
                    Positioned(
                      right: 8,
                      top: 70,
                      child: GestureDetector(
                        onTap: () {
                          // Swap starting location and destination here
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            border: Border.all(
                              color: AppColors.pureWhite,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.swap_vert,
                            color: AppColors.pureWhite,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Icon(Icons.search, color: AppColors.primary, size: 18,),
                    Text("Search places", style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight(900),
                      color: AppColors.primary,),),
                  ],
                ),
                Row(spacing: 10,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                        Text("Date",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight(
                            900), color: AppColors.ink,),),
                      InkWell(onTap: () {
                        Get.to(() => DateTimeScreen());
                      },
                        child: Container(padding: EdgeInsets.all(8),
                          width: double.infinity,
                          //height: 20.h,
                          decoration: BoxDecoration(
                            color: AppColors.veryLightBlue,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.sky_grey, width: 1),),
                          child: Row(spacing: 5,
                            children:
                            [Icon(Icons.calendar_month, color: AppColors.
                            primary, size: 20,),Obx(() {
                              final date = controller.selectedDate.value;

                              return Text(
                                date == null
                                    ? "Select date"
                                    : "${date.day}/${date.month}/${date.year}",
                              );
                            })],),
                      ),
                    )
                  ],),
              ),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text("Departure Time",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight(
                          900), color: AppColors.ink,),),
                    InkWell(onTap: () {
                      Get.to(() => DateTimeScreen());
                    },
                      child: Container(padding: EdgeInsets.all(8),
                        width: double.infinity,
                        //height: 20.h,
                        decoration: BoxDecoration(color: AppColors
                            .veryLightBlue,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.sky_grey, width: 1),),
                        child: Row(spacing: 5,
                          children: [
                            Icon(Icons.access_time_outlined,
                              color: AppColors.primary, size: 20,),
                            Obx(() {
                              final time = controller.selectedTime.value;

                              return Text(
                                time == null
                                    ? "Select time"
                                    : time.format(context),
                              );
                            })
                          ],),
                      ),
                    )
                  ],),
              )
            ],
          ),

          Custombutton(buttonText: "Generate Journey",
            buttonColor: AppColors.primary,
            TextColor: AppColors.pureWhite,
            showBoxShadow: true,
          onButtonTap: (){Get.to(()=>GeneratingJourney());},),

          ],
        ),
      ),
        15.verticalSpace,
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: 80.h,
          decoration: BoxDecoration(
            color: AppColors.sky_grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 20,
              ),
              Expanded(
                child: Text(
                  "TripCast checks the forecast at up to 5 points along your route, timed to when you expect to pass each one.",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted_grey,
                  ),
                ),
              ),
            ],
          ),
        )
        ],
      ),
    ),)
    )
    ,
    );
  }
}
