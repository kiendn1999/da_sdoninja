import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/controller/function_controller/navigate_controller.dart';
import 'package:da_sdoninja/app/data/model/review_model.dart';
import 'package:da_sdoninja/app/data/model/statis_model.dart';
import 'package:get/get.dart';

import '../../data/model/store_model.dart';
import '../../data/model/user_model.dart';

class ReviewChipController extends NavigateController {
  final CollectionReference collectionReferenceReview = FirebaseFirestore.instance.collection("review");
  final CollectionReference _collectionReferenceStatis = FirebaseFirestore.instance.collection("Statistics");
    final CollectionReference _collectionReferenceStore = FirebaseFirestore.instance.collection("Store");
  final CollectionReference _collectionReferenceCustomer = FirebaseFirestore.instance.collection("User");
  late Query _query;
  late Query _queryStatis;
  late String storeID;
  late RxList<RxList<ReviewModel>> listOfListReview = RxList<RxList<ReviewModel>>.generate(6, (index) => <ReviewModel>[].obs);
  late Rx<StatisModel> statis = StatisModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void getAllStatis() {
    _queryStatis = _collectionReferenceStatis.where("store_id", isEqualTo: storeID);
    statis.bindStream(_getStatis());
  }

  void getAllReview() {
    _query = collectionReferenceReview.where("store_id", isEqualTo: storeID).orderBy("review_date", descending: true);
    listOfListReview.asMap().forEach((index, element) => element.bindStream(_getAllOrderOfOneStage(ratingTypes[index])));
  }

  Stream<List<ReviewModel>> _getAllOrderOfOneStage(int rating) {
    // ignore: curly_braces_in_flow_control_structures
    if (rating == 6) return _query.snapshots().map((query) => query.docs.map((item) {
        Rx<StoreModel> store = StoreModel().obs;
          store.bindStream(_getStore(item["store_id"]));
          Rx<UserModel> customer = UserModel().obs;
          customer.bindStream(_getCustomer(item["user_id"]));
      return ReviewModel.fromMap(item, store, customer);
    }).toList());
    return _query.where('rating', isEqualTo: rating).snapshots().map((query) => query.docs.map((item) {
       Rx<StoreModel> store = StoreModel().obs;
          store.bindStream(_getStore(item["store_id"]));
          Rx<UserModel> customer = UserModel().obs;
          customer.bindStream(_getCustomer(item["user_id"]));
      return ReviewModel.fromMap(item, store, customer);
    }).toList());
  }

   Stream<StoreModel> _getStore(String storeID) => _collectionReferenceStore.doc(storeID).snapshots().map((query) => StoreModel.fromMap(query));
  Stream<UserModel> _getCustomer(String userID) => _collectionReferenceCustomer.doc(userID).snapshots().map((query) => UserModel.fromMap(query));

  Stream<StatisModel> _getStatis() {
    return _queryStatis.snapshots().map((query) => query.docs.map((item) => StatisModel.fromMap(item)).toList()[0]);
  }

  int getRatingTypeCount(int index) {
    switch (index) {
      case 6:
        return statis.value.all!;
      case 5:
        return statis.value.five!;
      case 4:
        return statis.value.four!;
      case 3:
        return statis.value.three!;
      case 2:
        return statis.value.two!;
      case 1:
        return statis.value.one!;
      default:
        return 0;
    }
  }
}
