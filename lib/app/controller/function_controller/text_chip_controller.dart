import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/controller/function_controller/navigate_controller.dart';
import 'package:da_sdoninja/app/data/model/order_model.dart';
import 'package:da_sdoninja/app/data/network/api/notify_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TextChipController extends NavigateController {
  
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final NotifyApiService _notifyApiService = NotifyApiService();

  late Query _collectionReference;
  late RxList<RxList<OrderModel>> listOfListOrder = RxList<RxList<OrderModel>>.generate(8, (index) => <OrderModel>[].obs);

  void getOrdersOfAllStage(String? currentID, String filterTypeString) {
   pageController = PageController(initialPage: currentIndex);
    _collectionReference = _firebaseFirestore.collection("Order").where(filterTypeString, isEqualTo: currentID).orderBy("request_date", descending: true);
    listOfListOrder.asMap().forEach((index, element) => element.bindStream(_getAllOrder(stageList[index])));
  }

  Stream<List<OrderModel>> _getAllOrder(String stage) =>
      _collectionReference.where('stage', isEqualTo: stage).snapshots().map((query) => query.docs.map((item) => OrderModel.fromMap(item)).toList());
}
