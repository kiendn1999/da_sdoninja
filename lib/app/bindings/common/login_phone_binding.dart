import 'package:da_sdoninja/app/controller/page_controller/common/form_login_phone_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class LoginWithPhoneBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormLoginWithPhoneController>(() { 
      return FormLoginWithPhoneController();
    });
  }
}