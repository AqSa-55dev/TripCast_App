import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
class CustomSmallCircleButton extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final double? size;
  final bool isIcon;
  final String? text;
  final void Function()? onButtonTap;
  const CustomSmallCircleButton({super.key,  this.icon, this.onButtonTap, this.iconColor, this.size, required this.isIcon, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonTap,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 44.h,
        width: 44.w,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          shape: BoxShape.circle,boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12), // Light, subtle shadow
            blurRadius: 12, // Softness of the shadow
            spreadRadius: 1, // How far the shadow extends
            offset: const Offset(0, 4), // Moves shadow 4px down
          ),
        ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: isIcon?Icon(icon, color: iconColor, size: size): Text(text!, style: TextStyle(fontWeight: FontWeight(900), color: AppColors.primary, fontSize: 18),),
          // child: Icon(
          //   Icons.chevron_left_outlined,
          //   color: AppColors.ink,
          //   size: 25,
          // ),
        ),
      ),
    );
  }
}