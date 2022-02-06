import 'package:da_sdoninja/app/controller/page_controller/partner/my_store_controller.dart';
import 'package:get/get.dart';

import '../../controller/page_controller/partner/add_store_controller.dart';

class AddStoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyStoreController>(() {
      return MyStoreController();
    });
    Get.lazyPut<AddStoreController>(() {
      return AddStoreController();
    });
  }
}
