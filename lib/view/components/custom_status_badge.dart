
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/utils/app_colors.dart';

class CustomStatusBadge extends StatelessWidget {
  final String status;

  const CustomStatusBadge({
    super.key,
    this.status = "Caution",
  });

  @override
  Widget build(BuildContext context) {
    // Check which status is passed (Suitable, Caution, Unfavorable)
    bool isSuitable = status.toLowerCase() == "suitable";
    bool isUnfavorable = status.toLowerCase() == "unfavorable";

    Color bgColor = isSuitable
        ? AppColors.soft_green
        : (isUnfavorable ? AppColors.light_red : AppColors.caution_yellow);

    Color textColor = isSuitable
        ? AppColors.green
        : (isUnfavorable ? AppColors.red : AppColors.orange);

    IconData icon = isSuitable
        ? Icons.check_circle_outline
        : (isUnfavorable ? Icons.error_outline : Icons.warning_amber_outlined);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

