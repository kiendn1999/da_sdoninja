import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/extension/datetime_extension.dart';

class OrderModel {
  String? id;
  String? brokenCause;
  String? customerAddress;
  String? customerAva;
  String? customerId;
  String? customerName;
  String? deviceName;
  String? estimatedCompletionTime;
  String? repairCompletedDate;
  String? repairCost;
  String? requestDate;
  String? stage;
  String? storeAva;
  String? storeId;
  String? storeName;
  String? storeOwnerID;
  bool? isCommented;
  String? storeType;
  String? customerPhone;

  OrderModel({
    this.id,
    this.brokenCause,
    this.customerAddress,
    this.customerAva,
    this.customerId,
    this.customerName,
    this.deviceName,
    this.estimatedCompletionTime,
    this.repairCompletedDate,
    this.repairCost,
    this.requestDate,
    this.stage,
    this.storeAva,
    this.storeId,
    this.storeName,
    this.storeOwnerID,
    this.isCommented = false,
    this.storeType,
    this.customerPhone
  });

  factory OrderModel.fromMap(DocumentSnapshot data) {
    return OrderModel(
      id: data.id,
      brokenCause: data['broken_cause'],
      customerAddress: data['customer_address'],
      customerAva: data['customer_ava'],
      customerId: data['customer_id'],
      customerName: data['customer_name'],
      deviceName: data['device_name'],
      estimatedCompletionTime: data['estimated_completion_time'] == null ? null : data['estimated_completion_time'].toString(),
      repairCompletedDate: data['repair_completed_date'] == null ? null : DateTime.parse(data['repair_completed_date']).formatDateTimeString,
      repairCost: data['repair_cost'] == null ? null : data['repair_cost'].toString(),
      requestDate: DateTime.parse(data['request_date']).formatDateTimeString,
      stage: data['stage'],
      storeAva: data['store_ava'],
      storeId: data['store_id'],
      storeName: data['store_name'],
      storeOwnerID: data['store_owner_id'],
      isCommented: data['is_commented'],
      storeType: data['store_type'],
      customerPhone: data['customer_phone']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'broken_cause': brokenCause,
      'customer_address': customerAddress,
      'customer_ava': customerAva,
      'customer_id': customerId,
      'customer_name': customerName,
      'device_name': deviceName,
      'estimated_completion_time': estimatedCompletionTime,
      'repair_completed_date': repairCompletedDate,
      'repair_cost': repairCost,
      'request_date': requestDate,
      'stage': stage,
      'store_ava': storeAva,
      'store_id': storeId,
      'store_name': storeName,
      'store_owner_id': storeOwnerID,
      'is_commented': isCommented,
      'store_type': storeType,
      'customer_phone':customerPhone
    };
  }
}
