// ignore: curly_braces_in_flow_control_structures
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/controller/function_controller/drop_down_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/location_detect_cotroller.dart';
import 'package:da_sdoninja/app/data/model/notify_model.dart';
import 'package:da_sdoninja/app/data/model/order_model.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/data/network/api/notify_api.dart';
import 'package:da_sdoninja/app/data/repository/user_info.dart';
import 'package:da_sdoninja/app/extension/datetime_extension.dart';
import 'package:da_sdoninja/app/extension/geocoding_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:da_sdoninja/app/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tiengviet/tiengviet.dart';

class HomeCustomerController extends LocationDetectController with DropDownController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference _collectionReferenceStore;
  final NotifyApiService _notifyApiService = NotifyApiService();
  late CollectionReference _collectionReferenceOrder;
  final double _radius = 14;
  late GeoFirePoint _center;
  TextEditingController storeNameTextFieldController = TextEditingController();
  final _geo = Geoflutterfire();
  RxList<StoreModel> stores = <StoreModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    _collectionReferenceStore = _firebaseFirestore.collection("Store");
    _collectionReferenceOrder = _firebaseFirestore.collection("Order");
    getCurrentPosition();
    getLocation();
  }

  @override
  void onClose() {
    super.onClose();
    storeNameTextFieldController.dispose();
  }

  @override
  getLocation() {
    streamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) async {
      latitude = position.latitude;
      longitude = position.longitude;
      getAllStore();
      address = await GeocodingOnPosition.getAddressPostiton(position);
      addressTextFieldController.text = address;
    });
  }

  getAllStore() {
    if (dropdownSortValue == sortTypes[1])
      getAllStoreByRating();
    else
      getAllStoreByNear();
  }

  getAllStoreByNear() {
    _center = _geo.point(latitude: latitude, longitude: longitude);
    if (dropdownDeviceValue == storeTypes[0] && storeNameTextFieldController.text.isEmpty) {
      stores.bindStream(
          _geo.collection(collectionRef: _collectionReferenceStore).within(center: _center, radius: _radius, field: "position", strictMode: true).map((query) => query.map((item) {
                double distance = _center.distance(lat: item['position']['geopoint'].latitude, lng: item['position']['geopoint'].longitude);
                return StoreModel.fromMap(item, distance);
              }).toList()));
    } else {
      stores.bindStream(
          _geo.collection(collectionRef: _collectionReferenceStore).within(center: _center, radius: _radius, field: "position", strictMode: true).map((query) => query.map((item) {
                double distance = _center.distance(lat: item['position']['geopoint'].latitude, lng: item['position']['geopoint'].longitude);
                return StoreModel.fromMap(item, distance);
              }).where((store) {
                if (dropdownDeviceValue == storeTypes[0]) {
                  return TiengViet.parse(store.storeName!.toLowerCase()).contains(TiengViet.parse(storeNameTextFieldController.text.toLowerCase()));
                }
                return store.storeType.contains(dropdownDeviceValue) &&
                    TiengViet.parse(store.storeName!.toLowerCase()).contains(TiengViet.parse(storeNameTextFieldController.text.toLowerCase()));
              }).toList()));
    }
  }

  getAllStoreByRating() {
    _center = _geo.point(latitude: latitude, longitude: longitude);
    if (dropdownDeviceValue == storeTypes[0] && storeNameTextFieldController.text.isEmpty) {
      stores.bindStream(_geo.collection(collectionRef: _collectionReferenceStore).within(center: _center, radius: _radius, field: "position", strictMode: true).map((query) => query
          .map((item) {
            double distance = _center.distance(lat: item['position']['geopoint'].latitude, lng: item['position']['geopoint'].longitude);
            return StoreModel.fromMap(item, distance);
          })
          .toList()
          .sorted((a, b) => b.rating!.compareTo(a.rating!))));
    } else {
      stores.bindStream(_geo.collection(collectionRef: _collectionReferenceStore).within(center: _center, radius: _radius, field: "position", strictMode: true).map((query) => query
          .map((item) {
            double distance = _center.distance(lat: item['position']['geopoint'].latitude, lng: item['position']['geopoint'].longitude);
            return StoreModel.fromMap(item, distance);
          })
          .where((store) {
            if (dropdownDeviceValue == storeTypes[0]) {
              return TiengViet.parse(store.storeName!.toLowerCase()).contains(TiengViet.parse(storeNameTextFieldController.text.toLowerCase()));
            }
            return store.storeType.contains(dropdownDeviceValue) &&
                TiengViet.parse(store.storeName!.toLowerCase()).contains(TiengViet.parse(storeNameTextFieldController.text.toLowerCase()));
          })
          .toList()
          .sorted((a, b) => b.rating!.compareTo(a.rating!))));
    }
  }

  @override
  Future<void> getCurrentPosition() async {
    if (addressTextFieldController.text.isEmpty) {
      Position? position = await Geolocator.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
      address = await GeocodingOnPosition.getAddressPostiton(position);
      getAllStore();
      addressTextFieldController.text = address;
    }
  }

  bool checkIsOpenStore(int index) {
    StoreModel store = stores[index];
    final now = DateTime.now();
    TimeOfDay startTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(store.openTime!));
    TimeOfDay endTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(store.closingTime!));
    DateTime start = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime end = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    return store.openStore! && store.dayClosed!.contains(DateTime.now().formatDateDefault) == false && now.isAfter(start) && now.isBefore(end);
  }

  Future<void> handleSendNotification(StoreModel store, String customerAddress) async {
    EasyLoading.show(indicator: const CircularProgressApp());
    await _notifyApiService.pushNotify(NotifyModel(
      externalUserID: store.ownerID,
      route: Routes.partnerNavigation,
      largeIcon: UserCurrentInfo.avaURL,
      nameInHeading: store.storeName,
      nameInContent: UserCurrentInfo.userName,
      contentEng: "You received a new trust from",
      contentVI: "Bạn nhận được một ủy thác từ",
    ).toMapPassive());

    _collectionReferenceOrder
        .add(OrderModel(
                customerAddress: customerAddress,
                customerAva: UserCurrentInfo.avaURL,
                customerId: UserCurrentInfo.userID,
                customerName: UserCurrentInfo.userName,
                requestDate: DateTime.now().toString(),
                stage: "pending",
                storeAva: store.avaUrl,
                storeId: store.id,
                storeName: store.storeName,
                storeOwnerID: store.ownerID,
                storeType: dropdownDeviceValue)
            .toMap())
        .catchError((onError) {
      snackBar(message: "submit_request_failed".tr);
      EasyLoading.dismiss();
      throw onError;
    });
    Get.back();
    snackBar(message: "request_sent_successfully".tr);
    EasyLoading.dismiss();
  }
}
