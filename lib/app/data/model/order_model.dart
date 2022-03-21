import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/data/model/user_model.dart';
import 'package:da_sdoninja/app/extension/datetime_extension.dart';
import 'package:get/get.dart';
import 'store_model.dart';

class OrderModel {
  String? id;
  String? brokenCause;
  String? customerAddress;
  String? customerId;
  String? deviceName;
  String? estimatedCompletionTime;
  String? repairCompletedDate;
  String? repairCost;
  String? requestDate;
  String? stage;
  String? storeId;
  String? storeOwnerID;
  Rx<StoreModel>? store = StoreModel().obs;
  Rx<UserModel>? customer = UserModel().obs;
  bool? isCommented;
  String? storeType;

  OrderModel({
    this.id,
    this.brokenCause,
    this.customerAddress,
    this.customerId,
    this.deviceName,
    this.estimatedCompletionTime,
    this.repairCompletedDate,
    this.repairCost,
    this.requestDate,
    this.stage,
    this.store,
    this.customer,
    this.storeId,
    this.storeOwnerID,
    this.isCommented = false,
    this.storeType,
  });

  factory OrderModel.fromMap(DocumentSnapshot data, [Rx<StoreModel>? store, Rx<UserModel>? customer]) {
    return OrderModel(
      id: data.id,
      brokenCause: data['broken_cause'],
      customerAddress: data['customer_address'],
      customerId: data['customer_id'],
      deviceName: data['device_name'],
      estimatedCompletionTime: data['estimated_completion_time'] == null ? null : data['estimated_completion_time'].toString(),
      repairCompletedDate: data['repair_completed_date'] == null ? null : DateTime.parse(data['repair_completed_date']).formatDateTimeString,
      repairCost: data['repair_cost'] == null ? null : data['repair_cost'].toString(),
      requestDate: DateTime.parse(data['request_date']).formatDateTimeString,
      stage: data['stage'],
      store: store,
      customer: customer,
      storeId: data['store_id'],
      storeOwnerID: data['store_owner_id'],
      isCommented: data['is_commented'],
      storeType: data['store_type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'broken_cause': brokenCause,
      'customer_address': customerAddress,
      'customer_id': customerId,
      'device_name': deviceName,
      'estimated_completion_time': estimatedCompletionTime,
      'repair_completed_date': repairCompletedDate,
      'repair_cost': repairCost,
      'request_date': requestDate,
      'stage': stage,
      'store_id': storeId,
      'store_owner_id': storeOwnerID,
      'is_commented': isCommented,
      'store_type': storeType,
    };
  }
}
