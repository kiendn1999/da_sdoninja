import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/extension/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/network/api/notify_api.dart';

class StoreDetailController extends GetxController {
  final NotifyApiService notifyApiService = NotifyApiService();

  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection("Store");
  final Rx<StoreModel> store = StoreModel().obs;
  Rx<String> distance = "0".obs;

  Future<void> getInfoStore(String storeID) async {
    store.bindStream(_getStore(storeID));
    Position currentPosition = await Geolocator.getCurrentPosition();
    distance.value =
        (Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, store.value.position!['geopoint'].latitude, store.value.position!['geopoint'].longitude) /
                1000)
            .toStringAsFixed(1);
  }

  Stream<StoreModel> _getStore(String storeID) => _collectionReference.doc(storeID).snapshots().map((query) => StoreModel.fromMap(query));

  shareStoreInfo() async {
    await Share.share(
        '${store.value.storeName}\n\nSố điện thoại: ${store.value.phoneNumber}\n\n${store.value.introduce}\nhttps://www.google.com/maps/search/?api=1&query=${store.value.address!.replaceAll(RegExp(' '), '+')}');
  }

  bool checkIsOpenStore() {
    StoreModel store = this.store.value;
    final now = DateTime.now();
    TimeOfDay startTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(store.openTime!));
    TimeOfDay endTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(store.closingTime!));
    DateTime start = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime end = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    return store.openStore! && store.dayClosed!.contains(DateTime.now().formatDateDefault) == false && now.isAfter(start) && now.isBefore(end);
  }
}
