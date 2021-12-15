import 'package:da_sdoninja/app/controller/page_controller/customer/customer_review_controller.dart';
import 'package:get/get.dart';

class CustomerReviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerReviewController>(() {
      return CustomerReviewController();
    });
  }
}
