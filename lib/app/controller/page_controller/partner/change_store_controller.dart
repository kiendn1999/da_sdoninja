import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/controller/function_controller/drop_down_controller.dart';
import 'package:da_sdoninja/app/data/hive/hive_helper.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../constant/string/string_array.dart';

class ChangeStoreController extends GetxController with DropDownController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString currentStoreID = "".obs;
  Rx<StoreModel> currentStore = StoreModel().obs;
  late Query _query;

  RxList<StoreModel> stores = RxList<StoreModel>();

  @override
  void onInit() {
    super.onInit();
    _query = _firebaseFirestore.collection("Store").where('ownerID', isEqualTo: _auth.currentUser!.uid);
    getAllStore();

    stores.listen((stores) {
      if (stores.isNotEmpty) {
        if (HiveHelper.currentStoreID == "") {
          currentStoreID.value = stores[0].id!;
          currentStore.value = stores[0];
          HiveHelper.saveCurrentStoreID(stores[0].id!);
        } else {
          currentStore.value = stores.singleWhere((element) => element.id!.contains(HiveHelper.currentStoreID));
          currentStoreID.value = HiveHelper.currentStoreID;
        }
      }
    });
  }

  getAllStore() {
    if (dropdownDeviceValue == storeTypes[0]) {
      stores.bindStream(_query.snapshots().map((query) => query.docs.map((item) => StoreModel.fromMap(item)).toList()));
    } else {
      stores.bindStream(_query.where("store_type", arrayContains: dropdownDeviceValue).snapshots().map((query) => query.docs.map((item) => StoreModel.fromMap(item)).toList()));
    }
  }

  changeStore(String currentStoreID) {
    this.currentStoreID.value = currentStoreID;
    HiveHelper.saveCurrentStoreID(currentStoreID);
    currentStore.value = stores.singleWhere((element) => element.id!.contains(currentStoreID));
    Get.back();
  }

  filterStoreType() {
    HiveHelper.saveCurrentStoreID("");
  }
}
