import 'package:da_sdoninja/app/controller/function_controller/cru_store_controller.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:da_sdoninja/app/widgets/snackbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class UpdateStoreController extends CrUStoreController {
   @override
  getDataToDisplayOnMyStoreScreen(StoreModel store) {
    super.getDataToDisplayOnMyStoreScreen(store);
    addressTextFieldController = TextEditingController(text: store.address);
  }
  
   Future<void> updateWithInfo(StoreModel store) async {
    if (checkInvalidFormUpdate) {
      EasyLoading.show(indicator: const CircularProgressApp());
      myLocation = geo.point(latitude: latitude, longitude: longitude);
      await uploadImgageAva();
      collectionReference.doc(store.id)
          .update(StoreModel.updateInfo(
                  avaUrl: imageUrl,
                  address: addressTextFieldController.text.trim(),
                  introduce: introduceTextFieldController.text.trim(),
                  phoneNumber: phoneTextFieldController.text.trim(),
                  position: store.address == addressTextFieldController.text ? store.position: myLocation.data,
                  storeName: nameTextFieldController.text.trim(),
                  storeServices: storeServiceList,
                  storeType: storeTypeCheckedList)
              .toMapUpdateInfo())
          .whenComplete(() {
        EasyLoading.dismiss();
        snackBar(message: "store_updated_successfully".tr);
      }).catchError((error) {
        EasyLoading.dismiss();
        snackBar(message: "store_update_failed".tr);
        throw error;
      });
    }
  }
}