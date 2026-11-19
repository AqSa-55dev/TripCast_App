
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateTimeController extends GetxController{

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  void updateTime(TimeOfDay time) {
    selectedTime.value = time;
  }
}