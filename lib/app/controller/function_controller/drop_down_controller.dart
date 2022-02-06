import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:get/get.dart';

mixin DropDownController on GetxController{
     final RxString _dropdownDeviceValue = storeTypes[0].obs;
   final RxString _dropdownFilterValue = "near_you".tr.obs;

     String get dropdownDeviceValue => _dropdownDeviceValue.value;

  set dropdownDeviceValue(String dropdownValue) {
    _dropdownDeviceValue.value = dropdownValue;
  }

  String get dropdownFilterValue => _dropdownFilterValue.value;

  set dropdownFilterValue(String dropdownFilterValue) {
    _dropdownFilterValue.value = dropdownFilterValue;
  }


}