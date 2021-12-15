import 'package:da_sdoninja/app/controller/page_controller/partner/manage_order_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/manage_review_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/partner_navigate_controller.dart';
import 'package:get/get.dart';

class PartnerNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerNavigateController>(() { 
      return PartnerNavigateController();
    });
    Get.lazyPut<ManageOrderController>(() {
      return ManageOrderController();
    });
    Get.lazyPut<ManageReivewController>(() {
      return ManageReivewController();
    });
  }
}