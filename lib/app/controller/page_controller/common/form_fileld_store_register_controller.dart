import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class FormFieldStoreRegisterController extends GetxController {
  final user = FirebaseAuth.instance.currentUser;
  final formKey = GlobalKey<FormState>();
  StoreModel store = StoreModel();
  late CollectionReference collectionReference;
  late TextEditingController nameController, addressController, phoneController;

  @override
  void onInit() {
    super.onInit();
    collectionReference = FirebaseFirestore.instance.collection("Store");
    nameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
  }

  String? validateStoreName(String? p1) {
    if (p1!.isEmpty) {
      return "Nhap ten cua hang";
    } else {
      store.storeName = p1;
      return null;
    }
  }

  String? validateStoreAddress(String? p1) {
    if (p1!.isEmpty) {
      return "Nhap dia chi";
    } else {
      store.addreess = p1;
      return null;
    }
  }

  String? validateStorePhone(String? p1) {
    if (p1!.isEmpty) {
      return "Nhap so dien thoai";
    } else {
      if (p1.isPhoneNumber) {
        store.phoneNumber = p1;
        return null;
      } else {
        return "So dien thoai khong hop le";
      }
    }
  }

  void summitInfo(String name, String address, String phone) {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(indicator: const CircularProgessApp());
      collectionReference.add({
        "store_name": name,
        "address": address,
        "phone_number": phone
      }).whenComplete(() {
        EasyLoading.dismiss();
      }).catchError((error) {
        EasyLoading.dismiss();
        Get.snackbar("Error", "Something went wrong");
      });
    }
  }
}
