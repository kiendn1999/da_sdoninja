import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/data/repository/user_info.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:da_sdoninja/app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as _firebase_storage;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../constant/theme/app_colors.dart';

class ProfileController extends GetxController {
  late final Rxn<User> _firebaseUser;
  String? _verificationId;

  String? get displayName => _firebaseUser.value?.displayName;
  String? get phoneNumber => _firebaseUser.value?.phoneNumber;
  String? get avaURL => _firebaseUser.value?.photoURL;

  String? _imageUrl;
  File? imageUserAva;
  RxBool didPickImage = false.obs;
  late final String? _filename;
  late final _firebase_storage.Reference ref;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    // TODO: implement onInit
    _firebaseUser = Rxn<User>(UserCurrentInfo.currentUser);
    _firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
    super.onInit();
  }

  updateProfile(String name, String phoneNumber) async {
    EasyLoading.show(indicator: const CircularProgressApp());
    if (phoneNumber.substring(0, 3) != "+84") phoneNumber = "+84" + phoneNumber.substring(1);
    if (name != displayName) {
      await UserCurrentInfo.currentUser!.updateDisplayName(name);
      await _saveUserNameIntoDB(name);
    }
    if (didPickImage.value) {
      await _uploadImgageAva();
      await UserCurrentInfo.currentUser!.updatePhotoURL(_imageUrl);
      await _savePhotoURL();
    }
    if (phoneNumber != this.phoneNumber) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            await UserCurrentInfo.currentUser!.updatePhoneNumber(phoneAuthCredential).whenComplete(() async {
              await _savePhoneNumberIntoDB(phoneNumber);
              snackBar(message: "phone_number_update_successful".tr);
              Get.back();
              Get.back();
            });
          },
          verificationFailed: (FirebaseAuthException authException) {
            EasyLoading.dismiss();
            snackBar(message: 'phone_number_verification_failed'.tr);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // snackBar(message: "verification code: " + verificationId);
            _verificationId = verificationId;
          },
          codeSent: (String verificationId, [int? forceResendingToken]) async {
            snackBar(message: 'please_check_your_phone'.tr);
            _verificationId = verificationId;
            Get.toNamed(Routes.otpVerification, arguments: [phoneNumber, 2]);
          },
        );
      } catch (e) {
        EasyLoading.dismiss();
        snackBar(message: "failed_to_verify_phone_number".tr);
      }
    }
    EasyLoading.dismiss();
  }

  Future<void> updatePhoneNumber({required String otpCode, required String phoneNumber}) async {
    EasyLoading.show(indicator: const CircularProgressApp());
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpCode,
      );

      await UserCurrentInfo.currentUser!.updatePhoneNumber(credential).whenComplete(() async {
        await _savePhoneNumberIntoDB(phoneNumber);
        Get.back();
        snackBar(message: "phone_number_update_successful".tr);
      });
    } catch (e) {
      EasyLoading.dismiss();
      snackBar(message: "the_otp_code_is_not_correct".tr);
    }
    EasyLoading.dismiss();
  }

  _saveUserNameIntoDB(String name) async {
    await FirebaseFirestore.instance.collection('User').doc(_firebaseUser.value!.uid).update({"user_name": name}).catchError((error) {
      snackBar(message: "updatename_failed".tr);
    });
  }

  _savePhotoURL() async {
    await FirebaseFirestore.instance.collection('User').doc(_firebaseUser.value!.uid).update({"ava_url": _imageUrl}).catchError((error) {
      snackBar(message: "updatename_failed".tr);
    });
  }

  _savePhoneNumberIntoDB(String phoneNumber) async {
    await FirebaseFirestore.instance.collection('User').doc(_firebaseUser.value!.uid).update({"phone_number": phoneNumber}).catchError((error) {
      snackBar(message: "phone_number_update_failed".tr);
    });
  }

  Future<void> _uploadImgageAva() async {
    if (imageUserAva != null) {
      ref = _firebase_storage.FirebaseStorage.instance.ref("custom ava/$_filename");
      await ref.putFile(imageUserAva!);
      _imageUrl = await ref.getDownloadURL();
    }
  }

  Future getImage(int typeGC) async {
    final XFile? pickedImage = await _picker.pickImage(source: typeGC == 1 ? ImageSource.gallery : ImageSource.camera).whenComplete(() => null);
    _filename = path.basename(pickedImage!.path);
    imageUserAva = await _cropImage(File(pickedImage.path));
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
}
