import 'package:da_sdoninja/app/controller/page_controller/common/authen_controller.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() {
      return AuthController();
    }, fenix: true);
  }
}
