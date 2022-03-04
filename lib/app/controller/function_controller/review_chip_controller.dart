import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/controller/function_controller/navigate_controller.dart';
import 'package:da_sdoninja/app/data/model/review_model.dart';
import 'package:da_sdoninja/app/data/model/statis_model.dart';
import 'package:get/get.dart';

class ReviewChipController extends NavigateController {
  final CollectionReference collectionReferenceReview = FirebaseFirestore.instance.collection("review");
  final CollectionReference _collectionReferenceStatis = FirebaseFirestore.instance.collection("Statistics");
  late Query _query;
  late Query _queryStatis;
  late  String storeID;
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
    if (rating == 6) return _query.snapshots().map((query) => query.docs.map((item) => ReviewModel.fromMap(item)).toList());
    return _query.where('rating', isEqualTo: rating).snapshots().map((query) => query.docs.map((item) => ReviewModel.fromMap(item)).toList());
  }

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
