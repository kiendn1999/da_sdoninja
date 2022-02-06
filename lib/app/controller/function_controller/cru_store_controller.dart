import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/location_detect_cotroller.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/data/repository/user_info.dart';
import 'package:da_sdoninja/app/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sms_autofill/sms_autofill.dart';

import '../../widgets/circular_progess.dart';

class CrUStoreController extends LocationDetectController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late CollectionReference collectionReference;
  late final firebase_storage.Reference ref;
  late TextEditingController nameTextFieldController, phoneTextFieldController, introduceTextFieldController;
  final SmsAutoFill autoFill = SmsAutoFill();
  final ImagePicker _picker = ImagePicker();
  late RxList<String> storeTypeCheckedList;
  final geo = Geoflutterfire();
  late RxList<String> storeServiceList;
  RxBool isDoneTermAndPolicyCheckBox = false.obs;
  final RxBool _isEdit = false.obs;
  late final String? _filename;
  bool _isValid = true;
  bool get isEdit => _isEdit.value;
  String? imageUrl;
  File? imageStoreAva;
  RxBool didPickImage = false.obs;
  late GeoFirePoint myLocation;

  @override
  void onInit() async {
    super.onInit();
    collectionReference = FirebaseFirestore.instance.collection("Store");
  }

  getDataToDisplayOnMyStoreScreen(StoreModel store) {
    nameTextFieldController = TextEditingController(text: store.storeName);
    phoneTextFieldController = TextEditingController(text: store.phoneNumber);
    introduceTextFieldController = TextEditingController(text: store.introduce);
    imageUrl = store.avaUrl;
    storeTypeCheckedList = store.storeType.obs;
    storeServiceList = store.storeServices.obs;
  }

  bool isStoreTypeChecked(String storeType) {
    return storeTypeCheckedList.contains(storeType);
  }

  checkStoreType(String storeType) {
    if (storeTypeCheckedList.contains(storeType))
      // ignore: curly_braces_in_flow_control_structures
      storeTypeCheckedList.remove(storeType);
    else
      // ignore: curly_braces_in_flow_control_structures
      storeTypeCheckedList.add(storeType);
  }

  bool isStoreServiceChecked(String storeService) {
    return storeServiceList.contains(storeService);
  }

  checkStoreService(String storeService) {
    if (storeServiceList.contains(storeService))
      // ignore: curly_braces_in_flow_control_structures
      storeServiceList.remove(storeService);
    else
      // ignore: curly_braces_in_flow_control_structures
      storeServiceList.add(storeService);
  }

  String? validateStoreName(String value) {
    if (value.trim().isEmpty) {
      return "do_not_leave_the_name_blank".tr;
    }
    if (value.trim().length < 10) {
      return "store_name_at_least_10_characters".tr;
    }
    return null;
  }

  String? validateStoreAddress(String value) {
    if (value.trim().isEmpty) {
      return "do_not_leave_the_address_blank".tr;
    }
    return null;
  }

  String? validateStorePhone(String value) {
    if (!GetUtils.isPhoneNumber(value)) {
      return "invalid_phone_number".tr;
    }
    return null;
  }

  String? validateStoreIntroduce(String value) {
    if (value.trim().isEmpty) {
      return "Dont_leave_the_intro_blank".tr;
    }
    if (value.trim().length < 50) {
      return "intro_at_least_50_characters".tr;
    }
    return null;
  }

  Future<void> submitWithInfo() async {
    if (formKey.currentState!.validate() && storeTypeCheckedList.isNotEmpty && isDoneTermAndPolicyCheckBox.value) {
      EasyLoading.show(indicator: const CircularProgessApp());
      myLocation = geo.point(latitude: latitude, longitude: longitude);
      await uploadImgageAva();
      collectionReference
          .add(StoreModel(
                  avaUrl: imageUrl,
                  address: addressTextFieldController.text,
                  closingTime: "5:00 PM",
                  introduce: introduceTextFieldController.text,
                  openStore: true,
                  openTime: "7:30 AM",
                  ownerID: UserCurrentInfo.userID,
                  phoneNumber: phoneTextFieldController.text,
                  position: myLocation.data,
                  storeName: nameTextFieldController.text,
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

  Future<void> uploadImgageAva() async {
    if (imageStoreAva != null) {
      ref = firebase_storage.FirebaseStorage.instance.ref("store ava/$_filename");
      await ref.putFile(imageStoreAva!);
      imageUrl = await ref.getDownloadURL();
    }
  }

  Future getImage(int typeGC) async {
    final XFile? pickedImage = await _picker.pickImage(source: typeGC == 1 ? ImageSource.gallery : ImageSource.camera);
    _filename = path.basename(pickedImage!.path);
    imageStoreAva = await _cropImage(File(pickedImage.path));
    didPickImage.value = true;
    Get.back();
  }

  _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'cropper'.tr,
            toolbarColor: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
            toolbarWidgetColor: AppColors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedImage;
  }

  bool get checkInvalidFormUpdate {
    _isValid = formKey.currentState!.validate() && storeTypeCheckedList.isNotEmpty;
    if (_isValid && _isEdit.value) {
      FocusManager.instance.primaryFocus?.unfocus();
      _isEdit.value = !_isEdit.value;
      return true;
    }
    if (_isEdit.value == false) _isEdit.value = !_isEdit.value;
    return false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameTextFieldController.dispose();
    addressTextFieldController.dispose();
    phoneTextFieldController.dispose();
    introduceTextFieldController.dispose();
  }
}
