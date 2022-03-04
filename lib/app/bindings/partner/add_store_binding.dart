import 'package:get/get.dart';

import '../../controller/page_controller/partner/add_store_controller.dart';

class AddStoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddStoreController>(() {
      return AddStoreController();
    });
  }
}
