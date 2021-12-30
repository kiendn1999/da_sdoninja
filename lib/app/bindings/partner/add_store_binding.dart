import 'package:da_sdoninja/app/controller/page_controller/partner/my_store_controller.dart';
import 'package:get/get.dart';

class AddStoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyStoreController>(() { 
      return MyStoreController();
    });
  }
}