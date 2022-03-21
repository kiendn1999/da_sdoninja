// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/data/model/order_model.dart';
import 'package:da_sdoninja/app/data/model/review_model.dart';
import 'package:da_sdoninja/app/data/model/statis_model.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../data/model/notify_model.dart';
import '../../../data/model/store_model.dart';
import '../../../data/network/api/notify_api.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/toast.dart';

class WriteReviewController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final NotifyApiService notifyApiService = NotifyApiService();
  final TextEditingController reviewTextFieldController = TextEditingController();
  final CollectionReference _collectionReferenceReview = FirebaseFirestore.instance.collection("review");
  final CollectionReference _collectionReferenceStatis = FirebaseFirestore.instance.collection("Statistics");
  final CollectionReference _collectionReferenceStore = FirebaseFirestore.instance.collection("Store");
  final CollectionReference _collectionReferenceOrder = FirebaseFirestore.instance.collection("Order");
  late Query _query;
  RxBool isCommented = false.obs;
  late Query _queryStatis;
  int _all = 0;
  int _ratingTotal = 0;
  double _ratingStore = 0;
  int _ratingReview = 5;
  String _ratingType = "five";
  String _ratingTypeOld = "five";
  int _ratingTypeCount = 0;
  int _ratingTypeCountOld = 0;
  final Rx<StoreModel> store = StoreModel().obs;

  final Rx<ReviewModel> review = ReviewModel().obs;
  final Rx<StatisModel> statis = StatisModel().obs;

  final RxString _satisfactionLevel = "very_good".tr.obs;

  String get satisfactionLevel => _satisfactionLevel.value;

  String? validateReview(String value) {
    if (value.trim().isEmpty) {
      return "do_not_leave_a_review_blank".tr;
    }
    if (value.trim().length < 10) {
      return "minimum_review_of_10_characters".tr;
    }
    return null;
  }

  void getDataReview(OrderModel order) {
    isCommented.value = order.isCommented!;
    _query = _collectionReferenceReview.where("order_id", isEqualTo: order.id);
    _queryStatis = _collectionReferenceStatis.where("store_id", isEqualTo: order.storeId);
    store.bindStream(_getStore(order.storeId!));
    store.listen((p0) async {
      if(p0.rating==0)  await _collectionReferenceStatis.add(StatisModel(storeID: order.storeId).toMap());
    });
    statis.bindStream(_getStatis());
    if (isCommented.value) {
      review.bindStream(_getReview());
      review.listen((review) {
        reviewTextFieldController.text = review.content!;
        setSatisfactionLevel(review.rating!);
      });
    } else
      setSatisfactionLevel(5);
  }

  Stream<ReviewModel> _getReview() {
    return _query.snapshots().map((query) => query.docs.map((item) => ReviewModel.fromMap(item)).toList()[0]);
  }

  Stream<StatisModel> _getStatis() {
    return _queryStatis.snapshots().map((query) => query.docs.map((item) => StatisModel.fromMap(item)).toList()[0]);
  }

  submitReview(OrderModel order) async {
    EasyLoading.show(indicator: const CircularProgressApp());
    late String contentEng, contentVI;
    _all = statis.value.all! + 1;
    _ratingTotal = statis.value.ratingTotal! + _ratingReview.toInt();
    _ratingStore = double.parse((_ratingTotal / _all).toStringAsFixed(1));

    contentEng = "evaluated the ${TiengViet.parse(order.deviceName!)} repair";
    contentVI = "đã đánh giá sửa chữa ${order.deviceName}";

    try {
      await notifyApiService.pushNotify(NotifyModel(
        externalUserID: order.storeOwnerID,
        route: Routes.partnerNavigation,
        largeIcon: order.customer!.value.avaUrl,
        nameInHeading: order.store!.value.storeName,
        nameInContent: order.customer!.value.userName,
        contentEng: contentEng,
        contentVI: contentVI,
      ).toMapActive());

      await _collectionReferenceReview.add(ReviewModel(
        content: reviewTextFieldController.text.trim(),
        deviceName: order.deviceName,
        brokenCause: order.brokenCause,
        orderID: order.id,
        price: int.parse(order.repairCost!),
        rating: _ratingReview.toInt(),
        reviewDate: DateTime.now().toString(),
        storeID: order.storeId,
        storeOwnerID: order.storeOwnerID,
        userID: order.customerId,
      ).toMap());

      _satisfactionNewLevelUpdate(_ratingReview);

      await _collectionReferenceStatis.doc(statis.value.id).update({"all": _all, _ratingType: _ratingTypeCount, "rating_total": _ratingTotal, "rating": _ratingStore});

      await _collectionReferenceOrder.doc(order.id).update({"is_commented": true});

      await _collectionReferenceStore.doc(order.storeId).update({"rating": _ratingStore, "rating_quantity": _all});
    } on Exception catch (e) {
      // TODO
      snackBar(message: "submit_a_failed_review".tr);
      EasyLoading.dismiss();
      throw e;
    }
    review.bindStream(_getReview());
    isCommented.value = true;
    snackBar(message: "submit_a_successful_review".tr);
    EasyLoading.dismiss();
  }

  Stream<StoreModel> _getStore(String storeID) => _collectionReferenceStore.doc(storeID).snapshots().map((query) => StoreModel.fromMap(query));

  updateReview(OrderModel order) async {
    _all = statis.value.all!;
    _ratingTotal = statis.value.ratingTotal! - review.value.rating! + _ratingReview.toInt();
    _ratingStore = double.parse((_ratingTotal / _all).toStringAsFixed(1));
    try {
      _satisfactionNewLevelUpdate(_ratingReview);
      _satisfactionOldLevelUpdate(review.value.rating!);
      int rating = _ratingReview;

      await _collectionReferenceStatis
          .doc(statis.value.id)
          .update({_ratingType: _ratingTypeCount, _ratingTypeOld: _ratingTypeCountOld, "rating_total": _ratingTotal, "rating": _ratingStore});

      await _collectionReferenceReview.doc(review.value.id).update({"rating": rating, "content": reviewTextFieldController.text});

      await _collectionReferenceStore.doc(order.storeId).update({"rating": _ratingStore});
    } on Exception catch (e) {
      // TODO
      snackBar(message: "submit_a_failed_review".tr);
      EasyLoading.dismiss();
      throw e;
    }
    showToast(msg: "saved".tr);
  }

  Future<void> deleteReview(OrderModel order) async {
    EasyLoading.show(indicator: const CircularProgressApp());
    _all = statis.value.all! - 1;
    _ratingTotal = statis.value.ratingTotal! - review.value.rating!;
    _ratingStore = double.parse((_ratingTotal / _all).toStringAsFixed(1));
    Get.back();
    try {
      _satisfactionOldLevelUpdate(review.value.rating!);

      await _collectionReferenceStatis.doc(statis.value.id).update({"all": _all, _ratingTypeOld: _ratingTypeCountOld, "rating_total": _ratingTotal, "rating": _ratingStore});

      await _collectionReferenceReview.doc(review.value.id).delete();

      await _collectionReferenceOrder.doc(order.id).update({"is_commented": false});

      await _collectionReferenceStore.doc(order.storeId).update({"rating": _ratingStore, "rating_quantity": _all});
    } on Exception catch (e) {
      // TODO
      snackBar(message: "submit_a_failed_review".tr);
      EasyLoading.dismiss();
      throw e;
    }
    snackBar(message: "review_removed".tr);
    isCommented.value = false;
    reviewTextFieldController.clear();

    EasyLoading.dismiss();
  }

  setSatisfactionLevel(int rating) {
    _ratingReview = rating;
    switch (rating) {
      case 1:
        _satisfactionLevel.value = "very_bad".tr;
        break;
      case 2:
        _satisfactionLevel.value = "bad".tr;
        break;
      case 3:
        _satisfactionLevel.value = "normal".tr;
        break;
      case 4:
        _satisfactionLevel.value = "good".tr;
        break;
      case 5:
        _satisfactionLevel.value = "very_good".tr;
        break;
      default:
    }
  }

  _satisfactionNewLevelUpdate(int rating) {
    switch (rating) {
      case 1:
        _ratingType = "one";
        _ratingTypeCount = statis.value.one! + 1;
        break;
      case 2:
        _ratingType = "two";
        _ratingTypeCount = statis.value.two! + 1;
        break;
      case 3:
        _ratingType = "three";
        _ratingTypeCount = statis.value.three! + 1;
        break;
      case 4:
        _ratingType = "four";
        _ratingTypeCount = statis.value.four! + 1;
        break;
      case 5:
        _ratingType = "five";
        _ratingTypeCount = statis.value.five! + 1;
        break;
      default:
    }
  }

  _satisfactionOldLevelUpdate(int rating) {
    switch (rating) {
      case 1:
        _ratingTypeOld = "one";
        _ratingTypeCountOld = statis.value.one! - 1;
        break;
      case 2:
        _ratingTypeOld = "two";
        _ratingTypeCountOld = statis.value.two! - 1;
        break;
      case 3:
        _ratingTypeOld = "three";
        _ratingTypeCountOld = statis.value.three! - 1;
        break;
      case 4:
        _ratingTypeOld = "four";
        _ratingTypeCountOld = statis.value.four! - 1;
        break;
      case 5:
        _ratingTypeOld = "five";
        _ratingTypeCountOld = statis.value.five! - 1;
        break;
      default:
    }
  }
}
