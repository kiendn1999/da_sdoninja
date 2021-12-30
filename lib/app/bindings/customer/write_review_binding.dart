import 'package:da_sdoninja/app/controller/page_controller/customer/store_detail_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/write_review_controller.dart';
import 'package:get/get.dart';

class WriteReviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WriteReviewController>(() {
      return WriteReviewController();
    });
  }
}