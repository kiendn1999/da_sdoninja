
import 'package:da_sdoninja/app/controller/page_controller/partner/change_store_controller.dart';
import 'package:get/get.dart';

class ManageStoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeStoreController>(() { 
      return ChangeStoreController();
    });
     Get.lazyPut<ChangeStoreController>(() {
      return ChangeStoreController();
    });
  }
}