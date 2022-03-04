import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/controller/function_controller/navigate_controller.dart';
import 'package:da_sdoninja/app/data/model/order_model.dart';
import 'package:da_sdoninja/app/data/network/api/notify_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TextChipController extends NavigateController {
  final NotifyApiService notifyApiService = NotifyApiService();

  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection("Order");
  late Query _query;
  late RxList<RxList<OrderModel>> listOfListOrder = RxList<RxList<OrderModel>>.generate(8, (index) => <OrderModel>[].obs);

  void getOrdersOfAllStage(String? currentID, String filterTypeString) {
    pageController = PageController(initialPage: currentIndex);
    _query = _collectionReference.where(filterTypeString, isEqualTo: currentID).orderBy("request_date", descending: true);
    listOfListOrder.asMap().forEach((index, element) => element.bindStream(_getAllOrderOfOneStage(stageList[index])));
  }

  Stream<List<OrderModel>> _getAllOrderOfOneStage(String stage) =>
      _query.where('stage', isEqualTo: stage).snapshots().map((query) => query.docs.map((item) => OrderModel.fromMap(item)).toList());

  Future<void> changeStageOfOrder(OrderModel order, String stage) async {
    await _collectionReference.doc(order.id).update({"stage": stage});
  }


  Future<void> deleteOrder(OrderModel order) async {
    await _collectionReference.doc(order.id).delete();
  }

  Future<void> updateOrder(String orderID, Map<String, dynamic> infoUpdate) async {
    await _collectionReference.doc(orderID).update(infoUpdate);
  }
}
