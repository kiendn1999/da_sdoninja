import 'package:get/get.dart';

class ProfileController extends GetxController {
   final RxBool _isEdit = false.obs;

  bool get isEdit => _isEdit.value;

  set isEdit(bool isEdit) {
    _isEdit.value = isEdit;
  }


}
