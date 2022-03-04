import 'package:da_sdoninja/app/controller/function_controller/text_chip_controller.dart';
import 'package:da_sdoninja/app/widgets/toast.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../data/model/notify_model.dart';
import '../../../data/model/order_model.dart';
import '../../../routes/app_routes.dart';

class PartnerOrderController extends TextChipController {
  List<List<GlobalKey<FormState>>> formKeysList = List<List<GlobalKey<FormState>>>.generate(2, (index) => <GlobalKey<FormState>>[]);
  List<List<TextEditingController>> deviceNameFieldControllerList = List<List<TextEditingController>>.generate(2, (index) => <TextEditingController>[]);
  List<List<TextEditingController>> brokenCauseFieldControllerList = List<List<TextEditingController>>.generate(2, (index) => <TextEditingController>[]);
  List<List<TextEditingController>> costFieldControllerList = List<List<TextEditingController>>.generate(2, (index) => <TextEditingController>[]);
  List<List<TextEditingController>> estimateTimeFieldControllerList = List<List<TextEditingController>>.generate(2, (index) => <TextEditingController>[]);

  void getOrdersOfAllStageOfStore(String? currentStoreID) {
    super.getOrdersOfAllStage(currentStoreID, 'store_id');
    listOfListOrder[2].listen((p0) {
      deviceNameFieldControllerList[0] = List.generate(p0.length, (index) => TextEditingController(text: p0[index].deviceName));
      brokenCauseFieldControllerList[0] = List.generate(p0.length, (index) => TextEditingController(text: p0[index].brokenCause));
      costFieldControllerList[0] = List.generate(p0.length, (index) => TextEditingController(text: p0[index].repairCost));
      estimateTimeFieldControllerList[0] = List.generate(p0.length, (index) => TextEditingController(text: p0[index].estimatedCompletionTime));
      formKeysList[0] = List.generate(p0.length, (index) => GlobalKey<FormState>());
    });
    listOfListOrder[3].listen((p0) {
      deviceNameFieldControllerList[1] = List.generate(p0.length, (index) => TextEditingController(text: p0[index].deviceName));
      brokenCauseFieldControllerList[1] = List.generate(p0.length, (index) => TextEditingController(text: p0[index].brokenCause));
      costFieldControllerList[1] = List.generate(p0.length, (index) => TextEditingController(text: p0[index].repairCost));
      estimateTimeFieldControllerList[1] = List.generate(p0.length, (index) => TextEditingController(text: p0[index].estimatedCompletionTime));
      formKeysList[1] = List.generate(p0.length, (index) => GlobalKey<FormState>());
    });
  }

  String? validateDeviceName(String value) {
    if (value.trim().isEmpty) {
      return "do_not_leave_the_name_blank".tr;
    }
    if (value.trim().length < 7) {
      return "device_name_at_least_7_characters".tr;
    }
    return null;
  }

  String? validatePrice(String value) {
    if (value.trim().isEmpty) {
      return "do_not_leave_the_repair_price_blank".tr;
    }
    return null;
  }

  String? validateEstimateTime(String value) {
    if (value.trim().isEmpty) {
      return "dont_leave_time_blank".tr;
    }
    return null;
  }

  String? validateBrokenCause(String value) {
    if (value.trim().isEmpty) {
      return "do_not_leave_the_broken_cause_blank".tr;
    }
    if (value.trim().length < 7) {
      return "broken_cause_at_least_7_characters".tr;
    }
    return null;
  }

  @override
  changeStageOfOrder(OrderModel order, String stage) async {
    late String contentEng, contentVI;
    switch (stage) {
      case "cancelled":
        contentEng = order.deviceName == null ? "canceled your device repair" : "canceled your ${TiengViet.parse(order.deviceName!)} repair";
        contentVI = order.deviceName == null ? "đã hủy sửa chữa thiết bị của bạn" : "đã hủy sữa chữa ${order.deviceName} của bạn";
        break;
      case "checking":
        contentEng = "has accepted your request";
        contentVI = "đã chấp nhận yêu cầu của bạn";
        break;
      case "fixed":
        contentEng = "has finished repairing your ${TiengViet.parse(order.deviceName!)}";
        contentVI = "đã sửa xong ${order.deviceName} của bạn";
        break;
      case "paid":
        contentEng = "received money to repair ${TiengViet.parse(order.deviceName!)}";
        contentVI = "đã nhận tiền sửa ${order.deviceName}";
        break;
      default:
    }
    await notifyApiService.pushNotify(NotifyModel(
      externalUserID: order.customerId,
      route: Routes.customerNavigation,
      largeIcon: order.storeAva,
      nameInHeading: order.customerName,
      nameInContent: order.storeName,
      contentEng: contentEng,
      contentVI: contentVI,
    ).toMapActive());
    await super.changeStageOfOrder(order, stage);
  }

  Future<void> saveInfoCheck(OrderModel order, int stageIndex, int index, {String? stage}) async {
    await super.updateOrder(order.id!, {
      "device_name": deviceNameFieldControllerList[stageIndex - 2][index].text.trim(),
      "broken_cause": brokenCauseFieldControllerList[stageIndex - 2][index].text.trim(),
      "repair_cost": costFieldControllerList[stageIndex - 2][index].text.trim() == "" ? null : int.parse(costFieldControllerList[stageIndex - 2][index].text.trim()),
      "estimated_completion_time":
          estimateTimeFieldControllerList[stageIndex - 2][index].text.trim() == "" ? null : int.parse(estimateTimeFieldControllerList[stageIndex - 2][index].text.trim()),
      "stage": stage ?? order.stage
    });
    showToast(msg: "saved".tr);
  }

  Future<void> informToCustomer(OrderModel order, int stageIndex, int index) async {
    var deviceName = deviceNameFieldControllerList[stageIndex - 2][index].text.trim();
    String contentEng = "has finished checking your ${TiengViet.parse(deviceName)}";
    String contentVI = "đã kiểm tra xong ${deviceName} của bạn";
    await notifyApiService.pushNotify(NotifyModel(
      externalUserID: order.customerId,
      route: Routes.customerNavigation,
      largeIcon: order.storeAva,
      nameInHeading: order.customerName,
      nameInContent: order.storeName,
      contentEng: contentEng,
      contentVI: contentVI,
    ).toMapActive());
    await super.updateOrder(order.id!, {
      "device_name": deviceName,
      "broken_cause": brokenCauseFieldControllerList[stageIndex - 2][index].text.trim(),
      "repair_cost": costFieldControllerList[stageIndex - 2][index].text.trim() == "" ? null : int.parse(costFieldControllerList[stageIndex - 2][index].text.trim()),
      "estimated_completion_time":
          estimateTimeFieldControllerList[stageIndex - 2][index].text.trim() == "" ? null : int.parse(estimateTimeFieldControllerList[stageIndex - 2][index].text.trim()),
      "stage": "checked"
    });
  }

  Future<void> startRepair(OrderModel order) async {
    String contentEng = "has started repairing your ${TiengViet.parse(order.deviceName!)}";
    String contentVI = "đã bắt đầu sửa ${order.deviceName} của bạn";
    await notifyApiService.pushNotify(NotifyModel(
      externalUserID: order.customerId,
      route: Routes.customerNavigation,
      largeIcon: order.storeAva,
      nameInHeading: order.customerName,
      nameInContent: order.storeName,
      contentEng: contentEng,
      contentVI: contentVI,
    ).toMapActive());
    await super.updateOrder(order.id!, {"repair_completed_date": (DateTime.now().add(Duration(days: int.parse(order.estimatedCompletionTime!)))).toString(), "stage": "fixing"});
  }

  @override
  deleteOrder(OrderModel order) async {
    await notifyApiService.pushNotify(NotifyModel(
      externalUserID: order.customerId,
      route: Routes.customerNavigation,
      largeIcon: order.storeAva,
      nameInHeading: order.customerName,
      nameInContent: order.storeName,
      contentEng: "declined your request",
      contentVI: "đã từ chối yêu cầu của bạn",
    ).toMapActive());
    await super.deleteOrder(order);
  }
}
