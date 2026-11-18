import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../../components/custom_scaffold.dart';


class GeneratingJourney extends StatefulWidget {
  const GeneratingJourney({super.key});

  @override
  State<GeneratingJourney> createState() => _GeneratingJourneyState();
}

class _GeneratingJourneyState extends State<GeneratingJourney> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: true,
      child: SafeArea(
        child: Padding(
            padding: EdgeInsetsGeometry.all(10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("cancle",
                      style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]
                ),
        ),
      ),
    );
  }
}
