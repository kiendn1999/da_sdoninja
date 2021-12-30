import 'package:get/get.dart';

mixin DropDownController on GetxController{
     final _dropdownDeviceValue = "all_devices".tr.obs;
   final _dropdownFilterValue = "near_you".tr.obs;

  String get dropdownFilterValue => _dropdownFilterValue.value;

  set dropdownFilterValue(String dropdownFilterValue) {
    _dropdownFilterValue.value = dropdownFilterValue;
  }

  String get dropdownDeviceValue => _dropdownDeviceValue.value;

  set dropdownDeviceValue(String dropdownValue) {
    _dropdownDeviceValue.value = dropdownValue;
  }
}