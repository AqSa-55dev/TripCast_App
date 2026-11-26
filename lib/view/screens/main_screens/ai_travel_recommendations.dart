import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:trip_cast/utils/app_assets.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_small_circle_button.dart';

import '../../components/custom_scaffold.dart';

class AiTravelRecommendations extends StatefulWidget {
  const AiTravelRecommendations({super.key});

  @override
  State<AiTravelRecommendations> createState() => _AiTravelRecommendationsState();
}

class _AiTravelRecommendationsState extends State<AiTravelRecommendations> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: true,
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(spacing: 10,
              children: [
                CustomSmallCircleButton(isIcon: true, icon: Icons.keyboard_arrow_left,iconColor: AppColors.ink,onButtonTap: (){Get.back();},),
                Column(crossAxisAlignment: CrossAxisAlignment.start,spacing: 2,
                  children: [
                  Text("Travel Recommendations", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight(900),color: AppColors.ink),),
                  Text("Lahore to Islamabad · Thu, 12 Nov", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight(500),color: AppColors.muted_grey),)
                ],)
              ],
            ),

            Container(padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: AppColors.primary),
              child: Row(spacing: 3,
              children: [
                Container(padding: EdgeInsets.all(8),width: 32.w,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.15),),
                child: Icon(Icons.auto_awesome_outlined,size: 18,color: AppColors.pureWhite,),),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Generated automatically by Gemini ", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight(900),color: AppColors.pureWhite),),
                  Text("Based on your route's weather forecast", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight(500),color: AppColors.pureWhite),)
                ],)
              ],
            ),)
          ],
        ),
      ),
    );
  }
}
