import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/change_store_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/manage_review_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/partner_navigate_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/partner_order_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/schedule_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/update_store_controller.dart';
import 'package:get/get.dart';

class PartnerNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerNavigateController>(() {
      return PartnerNavigateController();
    });
    Get.lazyPut<PartnerOrderController>(() {
      return PartnerOrderController();
    });
    Get.lazyPut<ScheduleController>(() {
      return ScheduleController();
    });
    Get.lazyPut<ManageReviewController>(() {
      return ManageReviewController();
    });
    Get.lazyPut<ChangeStoreController>(() {
      return ChangeStoreController();
    });

    Get.lazyPut<ProfileController>(() {
      return ProfileController();
    });
    Get.lazyPut<UpdateStoreController>(() {
      return UpdateStoreController();
    });
  }
}
