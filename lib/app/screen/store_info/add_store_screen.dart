import 'package:da_sdoninja/app/screen/store_info/my_store_screen.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AddStoreScreen extends StatelessWidget {
  const AddStoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBarPopular(centerTitle: true, title: Text("add_a_new_store".tr)),
      endDrawer: const DrawerApp(),
      body: MyStoreScreen(isAddStoreScreen: true,),
    ));
  }
}
