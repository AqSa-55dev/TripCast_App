
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_button.dart';
import 'package:trip_cast/view/components/custom_scaffold.dart';
import 'package:trip_cast/view/components/custom_small_circle_button.dart';
import 'package:trip_cast/view/screens/main_screens/bottom_nav_screens/Explore_screen.dart';

import '../../../controller/date_time_controller.dart';

class DateTimeScreen extends StatefulWidget {
  const DateTimeScreen({super.key});

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {

  final DateTimeController controller = Get.find<DateTimeController>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.pureWhite,
              dialBackgroundColor: AppColors.soft_blue,
              dialHandColor: AppColors.pureWhite,
              dialTextColor: AppColors.ink,
              hourMinuteColor: AppColors.sky_grey,
              hourMinuteTextColor: AppColors.ink,
              dayPeriodColor: AppColors.sky_grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
         child: child!,
        );
      },
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),

    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });

      debugPrint('Selected time: ${pickedTime.format(context)}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(isBackgroundGradient: true,
      bottomNavigationBar: BottomAppBar(height: 120.h,
        color: AppColors.pureWhite,
        child: Column(spacing: 10,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text("Leaving",style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.muted_grey,
            ),),
              Text(
                "${_selectedDate == null ? 'Select date' : DateFormat('E, d MMM').format(_selectedDate!)} · "
                    "${_selectedTime == null ? 'Select time' : _selectedTime!.format(context)}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                ),
              )
          ],),
          Custombutton(buttonText: "Confirm", buttonColor: AppColors.primary, TextColor: AppColors.pureWhite,
          onButtonTap: (){if (_selectedDate == null || _selectedTime == null) {
            Get.snackbar(
              "Missing information",
              "Please select both date and departure time.",
            );
            return;
          }

          controller.selectedDate.value = _selectedDate;
          controller.selectedTime.value = _selectedTime;

          Get.back();},)
        ],
      ),),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                spacing: 10,
                children: [
                  CustomSmallCircleButton(
                    isIcon: true,
                    icon: Icons.arrow_back_ios_new_outlined,
                    iconColor: AppColors.ink,
                    onButtonTap: () {
                      Get.back();
                    },
                  ),
                  Text(
                    "When are you leaving?",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),

              15.verticalSpace,

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),boxShadow: [
                BoxShadow(
                color: Colors.black.withValues(alpha: 0.12), // Light, subtle shadow
                blurRadius: 12, // Softness of the shadow
                spreadRadius: 1, // How far the shadow extends
                offset: const Offset(0, 4), // Moves shadow 4px down
              ),
            ],
                ),
                child: Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: GoogleFonts.plusJakartaSansTextTheme(
                          Theme.of(context).textTheme,
                        ),
                        datePickerTheme: DatePickerThemeData(
                          headerHeadlineStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                          backgroundColor: AppColors.pureWhite,
                          headerBackgroundColor: AppColors.ink,
                          headerForegroundColor: Colors.white,
                          todayBackgroundColor:  WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary;
                            }
                            return Colors.transparent;
                          }),
                          todayForegroundColor:
                          WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.white;
                            }
                            return AppColors.ink;
                          }),
                          todayBorder: BorderSide(
                            color: AppColors.primary,
                          ),
                          dayForegroundColor:
                          WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.white;
                            }
                            return AppColors.ink;
                          }),
                          dayBackgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary;
                            }
                            return Colors.transparent;
                          }),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                      ),
                      child: CalendarDatePicker(
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                        onDateChanged: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                    ),
                    Align(alignment: AlignmentGeometry.centerStart, child: Text("Forecasts are available for the next 7 days.", style: TextStyle(fontSize: 12.sp, color: AppColors.muted_grey,),))
                  ],
                ),
              ),
              Text("Departure time", style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),),

              InkWell(onTap: selectTime,
                child: Container(
                  height: 45.h,
                  width: 111.w,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.pureWhite, border: Border.all(color: AppColors.border_grey, width: 1),borderRadius: BorderRadius.circular(22.r)),
                  child: Center(child: Text(_selectedTime == null
                      ? 'Select departure time'
                      : _selectedTime!.format(context),)),
                ),
              )
            ],
          ),

        ),
      ),

    );
  }
}
