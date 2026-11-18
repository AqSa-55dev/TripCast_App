import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:trip_cast/utils/app_assets.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/components/custom_scaffold.dart';
import 'package:trip_cast/view/components/custom_small_circle_button.dart';

class DateTimeScreen extends StatefulWidget {
  const DateTimeScreen({super.key});

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {

  List<DateTime?> _selectedDates = [];
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(isBackgroundGradient: true,
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row( spacing: 10,
                children: [
                CustomSmallCircleButton(isIcon: true, icon: Icons.arrow_back_ios_new_outlined,iconColor: AppColors.ink,onButtonTap: (){Get.back();},),
                Text("When are you leaving?", style: TextStyle(fontSize: 22,fontWeight: FontWeight.w900, color: AppColors.ink),)
              ],),
          CalendarDatePicker2(
        config: CalendarDatePicker2Config(
        calendarType: CalendarDatePicker2Type.single, // Options: single, multi, range
          selectedDayHighlightColor: Colors.indigo,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        ),
        value: _selectedDates,
        onValueChanged: (dates) {
          setState(() {
            _selectedDates = dates;
          });
        },
      ),
            ],
          ),
        ),
      ),
    ),);
  }
}
