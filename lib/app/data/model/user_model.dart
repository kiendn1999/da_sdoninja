import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userName;
  String? avaUrl;
  String? phoneNumber;
  UserModel({
    this.userName="summoning",
    this.avaUrl="",
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_name': userName,
      'ava_url': avaUrl,
      'phone_number': phoneNumber,
    };
  }

  factory UserModel.fromMap(DocumentSnapshot data) {
    return UserModel(
      userName: data['user_name'],
      avaUrl: data['ava_url'],
      phoneNumber: data['phone_number'],
    );
  }

}
