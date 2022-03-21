import 'package:da_sdoninja/app/controller/page_controller/customer/store_detail_controller.dart';
import 'package:get/get.dart';

import '../../controller/page_controller/customer/customer_review_controller.dart';

class StoreDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreDetailController>(() {
      return StoreDetailController();
    });
     Get.lazyPut<CustomerReviewController>(() {
      return CustomerReviewController();
    });
  }
}