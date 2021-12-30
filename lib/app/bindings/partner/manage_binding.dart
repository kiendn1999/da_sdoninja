

import 'package:da_sdoninja/app/controller/function_controller/change_store_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/manage_store_controller.dart';
import 'package:get/get.dart';

class ManageStoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageStoreController>(() { 
      return ManageStoreController();
    });
     Get.lazyPut<ChangeStoreController>(() {
      return ChangeStoreController();
    });
  }
}