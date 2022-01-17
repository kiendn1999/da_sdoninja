import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/controller/function_controller/drop_down_controller.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ManageStoreController extends GetxController with DropDownController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Query _query;

  RxList<StoreModel> stores = RxList<StoreModel>([]);

  @override
  void onInit() {
    super.onInit();
    _query = _firebaseFirestore.collection("Store").where('ownerID', isEqualTo: _auth.currentUser!.uid);
    stores.bindStream(getAllStore());
  }

  Stream<List<StoreModel>> getAllStore() => _query.snapshots().map((query) => query.docs.map((item) => StoreModel.fromMap(item)).toList());
}
