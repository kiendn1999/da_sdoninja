import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/constant/string/key_id.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/controller/function_controller/drop_down_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/location_detect_cotroller.dart';
import 'package:da_sdoninja/app/data/model/order_model.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/data/network/api/notify_api.dart';
import 'package:da_sdoninja/app/data/repository/user_info.dart';
import 'package:da_sdoninja/app/extension/geocoding_extension.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:da_sdoninja/app/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

class HomeCustomerController extends LocationDetectController with DropDownController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference _collectionReferenceStore;
  final NotifyApiService _notifyApiService = NotifyApiService();
  late CollectionReference _collectionReferenceOrder;
  late GeoFirePoint _center;
  TextEditingController storeNameTextFieldController = TextEditingController();
  final _geo = Geoflutterfire();
  RxList<StoreModel> stores = <StoreModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    _collectionReferenceStore = _firebaseFirestore.collection("Store");
    _collectionReferenceOrder = _firebaseFirestore.collection("Order");
    getLastPosition();
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
    _center = _geo.point(latitude: latitude, longitude: longitude);
    if (dropdownDeviceValue == storeTypes[0] && storeNameTextFieldController.text.isEmpty) {
      stores.bindStream(
          _geo.collection(collectionRef: _collectionReferenceStore).within(center: _center, radius: 14, field: "position", strictMode: true).map((query) => query.map((item) {
                double distance = _center.distance(lat: item['position']['geopoint'].latitude, lng: item['position']['geopoint'].longitude);
                return StoreModel.fromMap(item, distance);
              }).toList()));
    } else {
      stores.bindStream(
          _geo.collection(collectionRef: _collectionReferenceStore).within(center: _center, radius: 14, field: "position", strictMode: true).map((query) => query.map((item) {
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

  @override
  Future<void> getLastPosition() async {
    if (addressTextFieldController.text.isEmpty) {
      Position? position = await Geolocator.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
      address = await GeocodingOnPosition.getAddressPostiton(position);
      getAllStore();
      addressTextFieldController.text = address;
    }
  }

  Future<void> handleSendNotification(StoreModel store, String customerAddress) async {
    EasyLoading.show(indicator: const CircularProgessApp());
    await _notifyApiService.pushNotify({
      "app_id": oneSignalAppID,
      "android_channel_id": notifyChannelKey,
      "include_external_user_ids": [store.ownerID],
      "channel_for_external_user_ids": "push",
      "large_icon": UserCurrentInfo.avaURL,
      "headings": {"en": store.storeName, "vi": store.storeName},
      "contents": {"en": "You received a new trust from ${UserCurrentInfo.userName}", "vi": "Bạn nhận được một ủy thác từ ${UserCurrentInfo.userName}"},
    });
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
                storeType: "electrical_equipment")
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
