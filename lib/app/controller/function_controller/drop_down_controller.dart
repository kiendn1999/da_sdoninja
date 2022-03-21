import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:get/get.dart';

mixin DropDownController on GetxController{
     final RxString _dropdownDeviceValue = storeTypes[0].obs;
   final RxString _dropdownSortValue = sortTypes[0].obs;

     String get dropdownDeviceValue => _dropdownDeviceValue.value;

  set dropdownDeviceValue(String dropdownValue) {
    _dropdownDeviceValue.value = dropdownValue;
  }

  String get dropdownSortValue => _dropdownSortValue.value;

  set dropdownSortValue(String dropdownSortValue) {
    _dropdownSortValue.value = dropdownSortValue;
  }


}