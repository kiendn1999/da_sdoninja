import 'package:da_sdoninja/app/controller/function_controller/change_store_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/form_fileld_store_register_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/manage_order_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/manage_review_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/my_store_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/partner_navigate_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/schedule_controller.dart';
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
    Get.lazyPut<ScheduleController>(() {
      return ScheduleController();
    });
    Get.lazyPut<ManageReivewController>(() {
      return ManageReivewController();
    });
    Get.lazyPut<ChangeStoreController>(() {
      return ChangeStoreController();
    });
    Get.lazyPut<MyStoreController>(() {
      return MyStoreController();
    });
    Get.lazyPut<ProfileController>(() {
      return ProfileController();
    });
    Get.lazyPut<FormFieldStoreRegisterController>(() {
      return FormFieldStoreRegisterController();
    });
  }
}
