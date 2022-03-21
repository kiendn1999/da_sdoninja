import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StoreModel {
  String? id;
  String? address;
  Map<String, dynamic>? position;
  String? avaUrl;
  String? closingTime;
  List<String>? dayClosed;
  List<String> storeServices;
  String? introduce;
  double? distance;
  bool? openStore;
  String? openTime;
  String? ownerID;
  String? phoneNumber;
  num? rating;
  int? ratingQuantity;
  String? storeName;
  List<String> storeType;

  StoreModel({
    this.id,
    this.address,
    this.position,
    this.avaUrl="",
    this.closingTime,
    this.dayClosed = const <String>[],
    this.storeServices = const <String>[],
    this.introduce,
    this.distance,
    this.openStore,
    this.openTime,
    this.ownerID,
    this.phoneNumber,
    this.rating=0,
    this.ratingQuantity=0,
    this.storeName = "summoning",
    this.storeType = const <String>[],
  });

  StoreModel.updateInfo({
    this.address,
    this.position,
    this.avaUrl,
    this.storeServices = const <String>[],
    this.introduce,
    this.phoneNumber,
    this.storeName,
    this.storeType = const <String>[],
  });

  factory StoreModel.fromMap(DocumentSnapshot data, [double? distance]) {
    return StoreModel(
      id: data.id,
      address: data['address'],
      position: data['position'],
      avaUrl: data['ava_url'],
      closingTime: data['closing_time'],
      dayClosed: List<String>.from(data['day_closed']),
      storeServices: List<String>.from(data['store_services']),
      introduce: data['introduce'],
      openStore: data['open_store'],
      distance: distance,
      openTime: data['open_time'],
      ownerID: data['ownerID'],
      phoneNumber: data['phone_number'],
      rating: data['rating'],
      ratingQuantity: data['rating_quantity'],
      storeName: data['store_name'],
      storeType: List<String>.from(data['store_type']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'position': position,
      'ava_url': avaUrl,
      'closing_time': closingTime,
      'day_closed': dayClosed,
      'store_services': storeServices,
      'introduce': introduce,
      'distance': distance,
      'open_store': openStore,
      'open_time': openTime,
      'ownerID': ownerID,
      'phone_number': phoneNumber,
      'rating': rating,
      'rating_quantity': ratingQuantity,
      'store_name': storeName,
      'store_type': storeType,
    };
  }

  Map<String, dynamic> toMapUpdateInfo() {
    return {
      'address': address,
      'position': position,
      'ava_url': avaUrl,
      'store_services': storeServices,
      'introduce': introduce,
      'phone_number': phoneNumber,
      'store_name': storeName,
      'store_type': storeType,
    };
  }
}
