import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final Rx<TimeOfDay> _startTime = const TimeOfDay(hour: 7, minute: 0).obs;
  final Rx<TimeOfDay> _endTime = const TimeOfDay(hour: 23, minute: 30).obs;
  final RxList<DateTime> _closedDateList = <DateTime>[].obs;
  final RxBool _isStoreOpening = false.obs;

  bool get isStoreOpening => _isStoreOpening.value;

  set isStoreOpening(bool isStoreOpening) {
    _isStoreOpening.value = isStoreOpening;
  }

  TimeOfDay get startTime => _startTime.value;

  set startTime(TimeOfDay startTime) {
    _startTime.value = startTime;
  }

  TimeOfDay get endTime => _endTime.value;

  set endTime(TimeOfDay endTime) {
    _endTime.value = endTime;
  }

  List<DateTime> get closedDateList => _closedDateList;

  addClosedDate(DateTime closedDate) {
    _closedDateList.add(closedDate);
  }

  deleteClosedDate(DateTime closedDate) {
    _closedDateList.remove(closedDate);
  }
}
