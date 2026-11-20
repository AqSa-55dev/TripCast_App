
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/utils/app_assets.dart';
import 'package:trip_cast/utils/app_colors.dart';

class CustomStatusBadge extends StatelessWidget {
  const CustomStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 60.w,
      // height: 30.h,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.caution_yellow,borderRadius: BorderRadius.circular(15.r)),
      child: Row(spacing:5,
          children: [Icon(
          Icons.warning_amber_outlined,color: AppColors.orange, size: 14,),
          Text("Caution",style: TextStyle(color: AppColors.orange, fontSize: 12, fontWeight: FontWeight(900)), )
      ],),
    );
  }
}
