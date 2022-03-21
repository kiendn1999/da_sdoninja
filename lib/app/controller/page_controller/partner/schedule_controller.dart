// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/extension/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/model/store_model.dart';

class ScheduleController extends GetxController {
  final CollectionReference _collectionReferenceStore = FirebaseFirestore.instance.collection("Store");
  final Rx<TimeOfDay> _startTime = const TimeOfDay(hour: 7, minute: 0).obs;
  final Rx<TimeOfDay> _endTime = const TimeOfDay(hour: 23, minute: 30).obs;
  final RxBool _isStoreOpening = false.obs;
  final Rx<StoreModel> store = StoreModel().obs;
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection("Store");

  getInfoStore(String storeID) {
    store.bindStream(_getStore(storeID));
    store.listen((p0) {
      isStoreOpening = p0.openStore!;
      startTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(p0.openTime!));
      endTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(p0.closingTime!));
    });
  }

  openOrCloseStore(String storeID, bool value) {
    _collectionReference.doc(storeID).update({"open_store": value});
  }

  updateOpenTime(String storeID) async {
   TimeOfDay? openTime = await _selectAndShowTimePicker(
      helpText: "choose_opening_time".tr,
      initialTime: startTime,
    );
    if(openTime !=null)
    await _collectionReference.doc(storeID).update({"open_time": openTime.format(Get.context!)});
  }

  updateCloseTime(String storeID) async {
    TimeOfDay? closeTime = await _selectAndShowTimePicker(
      helpText: "choose_opening_time".tr,
      initialTime: endTime,
    );
    if(closeTime !=null)
    await _collectionReference.doc(storeID).update({"closing_time": closeTime.format(Get.context!)});
  }

  addDateClose(String storeID) async {
    DateTime? dateTime = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      cancelText: "cancel".tr,
      fieldLabelText: "enter_date".tr,
      helpText: "select_closing_date".tr,
      fieldHintText: "month_date_year".tr,
      errorFormatText: "malformed_date".tr,
      errorInvalidText: "out_of_range".tr,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (dateTime != null)
      _collectionReference.doc(storeID).update({
        "day_closed": FieldValue.arrayUnion([dateTime.formatDateDefault])
      });
  }

  deleteDateClose(String storeID, String dateTime) {
    _collectionReference.doc(storeID).update({
      "day_closed": FieldValue.arrayRemove([dateTime])
    });
  }

  Future<TimeOfDay?> _selectAndShowTimePicker({String? helpText, required TimeOfDay initialTime}) async {
    return await showTimePicker(
      context: Get.context!,
      helpText: helpText,
      cancelText: "cancel".tr,
      errorInvalidText: "enter_a_valid_time".tr,
      hourLabelText: "hour".tr,
      minuteLabelText: "minute".tr,
      initialTime: initialTime,
    );
  }

  Stream<StoreModel> _getStore(String storeID) => _collectionReference.doc(storeID).snapshots().map((query) => StoreModel.fromMap(query));

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
}
