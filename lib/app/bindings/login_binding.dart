import 'package:da_sdoninja/app/controller/page_controller/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() {
      return LoginController();
    });
  }
}