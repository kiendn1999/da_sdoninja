import 'package:da_sdoninja/app/controller/function_controller/text_chip_controller.dart';
import 'package:da_sdoninja/app/data/repository/user_info.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../data/model/notify_model.dart';
import '../../../data/model/order_model.dart';
import '../../../routes/app_routes.dart';

class CustomerOrderController extends TextChipController {

   void getOrdersOfAllStageOfStore() {
    super.getOrdersOfAllStage(UserCurrentInfo.userID, 'customer_id');
  }

   @override
  changeStageOfOrder(OrderModel order, String stage) async {
    late String contentEng, contentVI;
    switch (stage) {
      case "cancelled":
        contentEng = order.deviceName == null ? "canceled equipment repair" : "canceled the ${TiengViet.parse(order.deviceName!)} repair";
        contentVI = order.deviceName == null ? "đã hủy sửa chữa thiết bị" : "đã hủy sữa chữa ${order.deviceName}";
        break;
      case "waiting_to_fix":
        contentEng = "agreed to repair the ${TiengViet.parse(order.deviceName!)}";
        contentVI = "đã đồng ý sửa chữa ${order.deviceName!}";
        break;
      case "paid":
        contentEng = "paid for the repair fee for the ${TiengViet.parse(order.deviceName!)}";
        contentVI = "đã thanh toán phí sửa chữa ${order.deviceName}";
        break;
      default:
    }
    await notifyApiService.pushNotify(NotifyModel(
      externalUserID: order.storeOwnerID,
      route: Routes.partnerNavigation,
      largeIcon: order.customerAva,
      nameInHeading: order.storeName,
      nameInContent: order.customerName,
      contentEng: contentEng,
      contentVI: contentVI,
    ).toMapActive());
    await super.changeStageOfOrder(order, stage);
  }
}

