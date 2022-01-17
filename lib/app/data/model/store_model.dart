import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  String? id;
  String? addreess;
  String? avaUrl;
  String? closingTime;
  List<String>? dayClosed;
  bool? delivery;
  String? introduce;
  bool? onSiteRepair;
  bool? openStore;
  String? openTime;
  String? ownerID;
  String? phoneNumber;
  double? rating;
  int? ratingQuantity;
  String? storeName;
  List<String>? storeType;

  StoreModel({
    this.id,
    this.addreess,
    this.avaUrl,
    this.closingTime,
    this.dayClosed,
    this.delivery,
    this.introduce,
    this.onSiteRepair,
    this.openStore,
    this.openTime,
    this.ownerID,
    this.phoneNumber,
    this.rating,
    this.ratingQuantity,
    this.storeName,
    this.storeType,
  });



  factory StoreModel.fromMap(DocumentSnapshot data) {
    return StoreModel(
      id: data.id,
      addreess: data['address'],
      avaUrl: data['ava_url'],
      closingTime: data['closing_time'],
      dayClosed: List<String>.from(data['day_closed']),
      delivery: data['delivery'],
      introduce: data['introduce'],
      onSiteRepair: data['on_site_repair'],
      openStore: data['open_store'],
      openTime: data['open_time'],
      ownerID: data['ownerID'],
      phoneNumber: data['phone_number'],
      rating: data['rating'],
      ratingQuantity: data['rating_quantity'],
      storeName: data['store_name'],
      storeType: List<String>.from(data['store_type']),
    );
  }

}
