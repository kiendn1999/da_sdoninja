import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/controller/function_controller/navigate_controller.dart';
import 'package:da_sdoninja/app/data/model/order_model.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/data/network/api/notify_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/model/user_model.dart';

class TextChipController extends NavigateController {
  final NotifyApiService notifyApiService = NotifyApiService();

  final CollectionReference _collectionReferenceOrder = FirebaseFirestore.instance.collection("Order");
  final CollectionReference _collectionReferenceStore = FirebaseFirestore.instance.collection("Store");
  final CollectionReference _collectionReferenceCustomer = FirebaseFirestore.instance.collection("User");
  late Query _query;
  late RxList<RxList<OrderModel>> listOfListOrder = RxList<RxList<OrderModel>>.generate(8, (index) => <OrderModel>[].obs);

  void getOrdersOfAllStage(String? currentID, String filterTypeString) {
    pageController = PageController(initialPage: currentIndex);
    _query = _collectionReferenceOrder.where(filterTypeString, isEqualTo: currentID).orderBy("request_date", descending: true);
    listOfListOrder.asMap().forEach((stageIndex, element) => element.bindStream(_getAllOrderOfOneStage(stageIndex)));
  }

  Stream<List<OrderModel>> _getAllOrderOfOneStage(int stageIndex) {
    return _query.where('stage', isEqualTo: stageList[stageIndex]).snapshots().map((query) => query.docs.map((item) {
          Rx<StoreModel> store = StoreModel().obs;
          store.bindStream(_getStore(item["store_id"]));
          Rx<UserModel> customer = UserModel().obs;
          customer.bindStream(_getCustomer(item["customer_id"]));
          return OrderModel.fromMap(item, store, customer);
        }).toList());
  }

  Stream<StoreModel> _getStore(String storeID) => _collectionReferenceStore.doc(storeID).snapshots().map((query) => StoreModel.fromMap(query));
  Stream<UserModel> _getCustomer(String storeID) => _collectionReferenceCustomer.doc(storeID).snapshots().map((query) => UserModel.fromMap(query));

  Future<void> changeStageOfOrder(OrderModel order, String stage) async {
    await _collectionReferenceOrder.doc(order.id).update({"stage": stage});
  }

  Future<void> deleteOrder(OrderModel order) async {
    await _collectionReferenceOrder.doc(order.id).delete();
  }

  Future<void> updateOrder(String orderID, Map<String, dynamic> infoUpdate) async {
    await _collectionReferenceOrder.doc(orderID).update(infoUpdate);
  }
}
