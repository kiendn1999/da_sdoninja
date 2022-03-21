import 'package:da_sdoninja/app/controller/page_controller/partner/add_store_controller.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/screen/store_info/my_store_screen.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStoreScreen extends StatelessWidget {
  AddStoreScreen({Key? key}) : super(key: key);
  final AddStoreController _addStoreController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBarPopular(centerTitle: true, title: Text("add_a_new_store".tr)),
      endDrawer: DrawerApp(),
      body: MyStoreScreen(
        currentStore: StoreModel(storeName: ""),
        controller: _addStoreController,
      ),
    ));
  }
}
