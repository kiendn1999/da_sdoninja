import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/data/model/user_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:da_sdoninja/app/extension/datetime_extension.dart';

class ReviewModel {
  String? id;
  String? content;
  String? deviceName;
  String? orderID;
  int? price;
  int? rating;
  String? respond;
  String? reviewDate;
  String? storeID;
  // String? storeName;
  // String? storeAva;
  String? storeOwnerID;
  //String? userAva;
  String? userID;
  //String? userName;
  String? brokenCause;
   Rx<StoreModel>? store = StoreModel().obs;
  Rx<UserModel>? customer = UserModel().obs;

  ReviewModel({
    this.id,
    this.content,
    this.deviceName,
    this.orderID,
    this.price,
    this.rating = 5,
    this.respond,
    this.reviewDate,
    this.storeID,
    // this.storeName,
    // this.storeAva,
    this.storeOwnerID,
   // this.userAva,
    this.store,
    this.customer,
    this.userID,
   // this.userName,
    this.brokenCause
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'device_name': deviceName,
      'order_id': orderID,
      'price': price,
      'rating': rating,
      'respond': respond,
      'review_date': reviewDate,
      'store_id': storeID,
      // 'store_name':storeName,
      // 'store_ava':storeAva,
      'store_owner_id': storeOwnerID,
     // 'user_ava': userAva,
      'user_id': userID,
      //'user_name': userName,
      'broken_cause': brokenCause
    };
  }

  factory ReviewModel.fromMap(DocumentSnapshot data, [Rx<StoreModel>? store, Rx<UserModel>? customer]) {
    return ReviewModel(
      id: data.id,
      content: data['content'],
      deviceName: data['device_name'],
      orderID: data['order_id'],
      price: data['price'],
      rating: data['rating'],
      respond: data['respond'],
      reviewDate: data['review_date'] == null ? null : DateTime.parse(data['review_date']).formatDateTimeString,
      storeID: data['store_id'],
      // storeName: data['store_name'],
      // storeAva: data['store_ava'],
      storeOwnerID: data['store_owner_id'],
    //  userAva: data['user_ava'],
       store: store,
      customer: customer,
      userID: data['user_id'],
    //  userName: data['user_name'],
      brokenCause: data['broken_cause'],
    );
  }

}
