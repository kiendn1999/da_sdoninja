// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:da_sdoninja/app/controller/function_controller/review_chip_controller.dart';
import 'package:da_sdoninja/app/data/model/review_model.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:da_sdoninja/app/widgets/snackbar.dart';
import 'package:da_sdoninja/app/widgets/toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../data/model/notify_model.dart';
import '../../../data/network/api/notify_api.dart';
import '../../../routes/app_routes.dart';

class ManageReviewController extends ReviewChipController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final NotifyApiService notifyApiService = NotifyApiService();
  final TextEditingController respondTextFieldController = TextEditingController();

  String? validateRespond(String value) {
    if (value.trim().isEmpty) {
      return "do_not_leave_feedback_blank".tr;
    }
    if (value.trim().length < 7) {
      return "reply_with_at_least_7_characters".tr;
    }
    return null;
  }

  updateRespond(ReviewModel review) async {
    if (formKey.currentState!.validate()) {
      await super.collectionReferenceReview.doc(review.id).update({"respond": respondTextFieldController.text.trim()});
      Get.back();
      showToast(msg: "saved".tr);
    }
  }

  deleteRespond(ReviewModel review) async {
    await super.collectionReferenceReview.doc(review.id).update({"respond": null});
    Get.back();
    showToast(msg: "deleted".tr);
  }

  submitRespond(ReviewModel review) async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(indicator: const CircularProgressApp());
      String contentEng = "has responded to ${TiengViet.parse(review.deviceName!)} repair review";
      String contentVI = "đã phản hồi đánh giá sửa chữa ${review.deviceName}";

      try {
        await notifyApiService.pushNotify(NotifyModel(
          externalUserID: review.userID,
          route: Routes.customerNavigation,
          largeIcon: review.storeAva,
          nameInHeading: review.userName,
          nameInContent: review.storeName,
          contentEng: contentEng,
          contentVI: contentVI,
        ).toMapActive());
        await super.collectionReferenceReview.doc(review.id).update({"respond": respondTextFieldController.text.trim()});
      } on Exception catch (e) {
        snackBar(message: "submit_feedback_failed".tr);
        EasyLoading.dismiss();
        throw e;
      }
      Get.back();
      snackBar(message: "feedback_sent".tr);
      EasyLoading.dismiss();
    }
  }
}
