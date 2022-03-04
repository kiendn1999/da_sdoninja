import 'package:da_sdoninja/app/controller/function_controller/cru_store_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../data/model/store_model.dart';
import '../../../data/repository/user_info.dart';
import '../../../widgets/circular_progess.dart';
import '../../../widgets/snackbar.dart';

class AddStoreController extends CrUStoreController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    super.getCurrentPosition();
    super.getLocation();
  }

  @override
  Future<void> submitWithInfo() async {
    if (formKey.currentState!.validate() && storeTypeCheckedList.isNotEmpty && isDoneTermAndPolicyCheckBox.value) {
      EasyLoading.show(indicator: const CircularProgressApp());
      myLocation = geo.point(latitude: latitude, longitude: longitude);
      await uploadImgageAva();
      collectionReference
          .add(StoreModel(
                  avaUrl: imageUrl,
                  address: addressTextFieldController.text.trim(),
                  closingTime: "5:00 PM",
                  introduce: introduceTextFieldController.text.trim(),
                  openStore: true,
                  openTime: "7:30 AM",
                  ownerID: UserCurrentInfo.userID,
                  phoneNumber: phoneTextFieldController.text.trim(),
                  position: myLocation.data,
                  storeName: nameTextFieldController.text.trim(),
                  storeServices: storeServiceList,
                  storeType: storeTypeCheckedList)
              .toMap())
          .whenComplete(() {
        EasyLoading.dismiss();
        snackBar(message: "successfully_created_a_new_store".tr);
      }).catchError((error) {
        EasyLoading.dismiss();
        snackBar(message: "new_store_creation_failed".tr);
        throw error;
      });
    }
  }
}
