import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/extension/datetime_extension.dart';

class OrderModel {
  String? brokenCause;
  String? customerAddress;
  String? customerAva;
  String? customerId;
  String? customerName;
  String? deviceName;
  int? estimatedCompletionTime;
  String? repairCompletedDate;
  int? repairCost;
  String? requestDate;
  String? stage;
  String? storeAva;
  String? storeId;
  String? storeName;
  String? storeType;

  OrderModel({
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
    this.storeType,
  });

  factory OrderModel.fromMap(DocumentSnapshot data) {
    return OrderModel(
      brokenCause: data['broken_cause'],
      customerAddress: data['customer_address'],
      customerAva: data['customer_ava'],
      customerId: data['customer_id'],
      customerName: data['customer_name'],
      deviceName: data['device_name'],
      estimatedCompletionTime: data['estimated_completion_time'],
      repairCompletedDate: data['repair_completed_date'],
      repairCost: data['repair_cost'],
      requestDate: DateTime.parse(data['request_date']).formatDateTimeString,
      stage: data['stage'],
      storeAva: data['store_ava'],
      storeId: data['store_id'],
      storeName: data['store_name'],
      storeType: data['store_type'],
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
      'store_type': storeType,
    };
  }
}
