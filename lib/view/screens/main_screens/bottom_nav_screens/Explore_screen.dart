import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_scaffold.dart';

import '../../../../utils/app_assets.dart';
import '../../../components/custom_button.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(isBackgroundGradient: true,
      child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Plan your journey", style: TextStyle(color: AppColors.ink, fontSize: 28, fontWeight: FontWeight(1000)),),
          Text("Tell us where and when. We check the weather on the way.", style: TextStyle(color: AppColors.muted_grey, fontSize: 14, fontWeight: FontWeight(500)),),

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
                Text("Starting Location",style: TextStyle(fontSize: 13, fontWeight: FontWeight(1000), color: AppColors.ink,),),
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

                Text("Destination",style: TextStyle(fontSize: 13, fontWeight: FontWeight(1000), color: AppColors.ink,),),

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
                Row(
                  children: [
                    Icon(Icons.search, color: AppColors.primary,size: 18,),
                    Text("Search places",style: TextStyle(fontSize: 14, fontWeight: FontWeight(1000), color: AppColors.primary,),),
                  ],
                ),
                Row(
                  children: [
                    Column(children: [
                      Text("Date",style: TextStyle(fontSize: 13, fontWeight: FontWeight(1000), color: AppColors.ink,),),
                      Container(padding: EdgeInsets.all(8),
                        width: double.infinity.w,
                        //height: 20.h,
                        decoration: BoxDecoration(color: AppColors.veryLightBlue,borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.sky_grey, width: 1),),
                        child: Row(children: [Icon(Icons.calendar_month, color: AppColors.primary,size: 20,),Text("Thurs")],),
                      )
                    ],),
                    Column(children: [
                      Text("Departure time",style: TextStyle(fontSize: 13, fontWeight: FontWeight(1000), color: AppColors.ink,),),

                    ],)
                  ],
                ),

                Custombutton(buttonText: "Generate Journey", buttonColor: AppColors.primary, TextColor: AppColors.pureWhite,showBoxShadow: true,),
                Positioned(
                    top: 180,
                    left: 500,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary,boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12), // Light, subtle shadow
                          blurRadius: 12, // Softness of the shadow
                          spreadRadius: 1, // How far the shadow extends
                          offset: const Offset(0, 4), // Moves shadow 4px down
                        ),
                      ],
                          border: Border.all(width: 2, color: AppColors.pureWhite)),
                      child: Icon(Icons.swap_vert, color: AppColors.pureWhite,size: 20,),
                    )),
              ],
            ),
          ),
        ],
      )),);
  }
}
