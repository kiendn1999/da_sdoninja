
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/customer_navigate_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/customer_order_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/honme_custom_controller.dart';
import 'package:get/get.dart';

class CustomerNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerNavigateController>(() {
      return CustomerNavigateController();
    });
    Get.lazyPut<CustomerOrderController>(() {
      return CustomerOrderController();
    });
    Get.lazyPut<ProfileController>(() {
      return ProfileController();
    });
     Get.lazyPut<HomeCustomerController>(() {
      return HomeCustomerController();
    });
  }
}
