import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:da_sdoninja/app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  late final Rxn<User> _firebaseUser;
  String? _verificationId;

  String? get displayName => _firebaseUser.value?.displayName;
  String? get phoneNumber => _firebaseUser.value?.phoneNumber;
  String? get avaURL => _firebaseUser.value?.photoURL;

  updateProfile(String name, String phoneNumber) async {
    EasyLoading.show(indicator: const CircularProgessApp());
    if (phoneNumber.substring(0, 3) != "+84") phoneNumber = "+84" + phoneNumber.substring(1);
    if (name != displayName) {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await _saveUserNameIntoDB(name);
    }
    if (phoneNumber != this.phoneNumber) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            await FirebaseAuth.instance.currentUser!.updatePhoneNumber(phoneAuthCredential).whenComplete(() async {
              await _savePhoneNumberIntoDB(phoneNumber);
              snackBar(message: "phone_number_update_successful".tr);
              Get.back();
            });
          },
          verificationFailed: (FirebaseAuthException authException) {
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
        snackBar(message: "failed_to_verify_phone_number".tr);
      }
    }
    EasyLoading.dismiss();
  }

  Future<void> updatePhoneNumber({required String otpCode, required String phoneNumber}) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId.toString(),
        smsCode: otpCode,
      );

      await FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential).whenComplete(() async {
         await _savePhoneNumberIntoDB(phoneNumber);
        Get.back();
        snackBar(message: "phone_number_update_successful".tr);
      });
    } catch (e) {
      snackBar(message: "the_otp_code_is_not_correct".tr);
    }
  }

  _saveUserNameIntoDB(String name) async {
    await FirebaseFirestore.instance.collection('User').doc(_firebaseUser.value!.uid).update({"user_name": name}).catchError((error) {
      snackBar(message: "updatename_failed".tr);
    });
  }

  _savePhoneNumberIntoDB(String phoneNumber) async {
    await FirebaseFirestore.instance.collection('User').doc(_firebaseUser.value!.uid).update({"phone_number": phoneNumber}).catchError((error) {
      snackBar(message: "phone_number_update_failed".tr);
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    _firebaseUser = Rxn<User>(FirebaseAuth.instance.currentUser);
    _firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
    super.onInit();
  }
}
