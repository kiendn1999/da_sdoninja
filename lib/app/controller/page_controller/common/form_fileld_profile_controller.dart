import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FormFieldProfileController extends GetxController {
  final GlobalKey<FormState> updateProfileFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController userNameTextFieldController;
  late TextEditingController phomeNumberTextFieldController;
  final RxBool _isEdit = false.obs;
  bool _isValid = true;
  bool _isFirst = true;
  bool get isEdit => _isEdit.value;

  @override
  void onInit() {
    super.onInit();
    userNameTextFieldController = TextEditingController(text: _auth.currentUser!.displayName);
    phomeNumberTextFieldController = TextEditingController(text: _auth.currentUser!.phoneNumber);
  }

  @override
  void onClose() {
    userNameTextFieldController.dispose();
    phomeNumberTextFieldController.dispose();
  }

  String? validatePhoneNumber(String value) {
    if (!GetUtils.isPhoneNumber(value)) {
      return "invalid_phone_number".tr;
    }
    return null;
  }

  String? validateUserName(String value) {
    if (value.trim().isEmpty) {
      return "do_not_leave_the_name_blank".tr;
    }
    return null;
  }

  bool get checkInvalidForm {
    _isValid = updateProfileFormKey.currentState!.validate();
    if (_isValid || _isFirst) {
      _isEdit.value = !_isEdit.value;
      _isFirst = false;
    }
    if (!_isValid) {
      return false;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    return true;
  }
}
