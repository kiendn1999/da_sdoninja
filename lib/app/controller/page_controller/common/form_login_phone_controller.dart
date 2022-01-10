import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class FormLoginWithPhoneController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final SmsAutoFill autoFill = SmsAutoFill();
  late TextEditingController phoneNumberTextFieldController;

  @override
  void onInit() {
    super.onInit();
    phoneNumberTextFieldController = TextEditingController();
  }

  @override
  void onClose() {
    phoneNumberTextFieldController.dispose();
  }

  String? validatePhoneNumber(String value) {
    if (!GetUtils.isPhoneNumber(value)) {
      return "invalid_phone_number".tr;
    }
    return null;
  }

  bool get checkInvalidPhoneNumberToVerify {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    return true;
  }
}
