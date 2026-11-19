import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_cast/view/components/custom_button.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../components/custom_scaffold.dart';

class GeneratingJourney extends StatefulWidget {
  const GeneratingJourney({super.key});

  @override
  State<GeneratingJourney> createState() => _GeneratingJourneyState();
}

class _GeneratingJourneyState extends State<GeneratingJourney> {

Widget progressItem(String title) {
    return Row(
      children: [
        Container(
          height: 27.h,
          width: 27.w,
          decoration: BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            size: 13.sp,
            color: Colors.white,
          ),
        ),

        12.horizontalSpace,

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isBackgroundGradient: true,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "cancle",
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              25.verticalSpace,

              SizedBox(
                height: 168.h,
                width: 168.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 150.h,
                      width: 150.w,
                      child: CircularProgressIndicator(
                        value: 0.35,
                        strokeWidth: 4.w,
                        backgroundColor: AppColors.muted_grey.withValues(alpha: 0.1),
                        color: AppColors.primary,
                        ),
                      ),
                    Container(
                      height: 110.h,
                      width: 110.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ]
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(AppAssets.splashIcon, scale: 2,),
                        ]

                      ),
                    ),


                  ],
                ),
              ),

              10.verticalSpace,

              Text(
                "Your journey is ready",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              Text(
                  "Lahore to Islamabad · Thu, 12 Nov · 8:00 AM",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w400,
                ),
              ),

              25.verticalSpace,

              Container(
                height: 168.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 18.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    progressItem("Finding your route"),
                    18.verticalSpace,
                    progressItem("Checking weather at 5 points"),
                    18.verticalSpace,
                    progressItem("Gemini is writing your advice"),
                  ],
                ),
              ),

              Spacer(),

              Custombutton(
                buttonText: "View Journey",
                buttonColor: AppColors.primary,
                TextColor: AppColors.pureWhite,
                onButtonTap: (){
                  // Get.to(()=>const PlanJourney());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}









































