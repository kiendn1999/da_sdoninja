import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/controller/function_controller/drop_down_controller.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:get/get.dart';

class HomeCustomerController extends GetxController with DropDownController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference _collectionReference;

  RxList<StoreModel> stores = RxList<StoreModel>([]);

  @override
  void onInit() {
    super.onInit();
    _collectionReference = _firebaseFirestore.collection("Store");
    stores.bindStream(getAllStore());
  }

  Stream<List<StoreModel>> getAllStore() => _collectionReference.snapshots().map((query) => query.docs.map((item) => StoreModel.fromMap(item)).toList());
}
