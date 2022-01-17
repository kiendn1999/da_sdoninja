import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_sdoninja/app/data/hive/hive_helper.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:da_sdoninja/app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential

    EasyLoading.show(indicator: const CircularProgessApp());
    await _auth.signInWithCredential(credential).whenComplete(() async {
      await _saveUserInDatabase();
      HiveHelper.saveIsFirstLogin(false);
      Get.offAllNamed(Routes.customerNavigation);
      EasyLoading.dismiss();
    });
  }

  Future<void> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    EasyLoading.show(indicator: const CircularProgessApp());
    await _auth.signInWithCredential(facebookAuthCredential).whenComplete(() async {
      await _saveUserInDatabase();
      HiveHelper.saveIsFirstLogin(false);
      Get.offAllNamed(Routes.customerNavigation);
      EasyLoading.dismiss();
    });
  }

  Future<void> signInWithPhoneNumber({required String otpCode}) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId.toString(),
        smsCode: otpCode,
      );

      await _auth.signInWithCredential(credential).whenComplete(() async {
        await _saveUserInDatabase();
        HiveHelper.saveIsFirstLogin(false);
        Get.offAllNamed(Routes.customerNavigation);
        snackBar(message: "logged_in_successfully".tr);
      });
    } catch (e) {
      snackBar(message: "login_failed".tr);
    }
  }

  Future<void> verifyPhoneNumber({required String phoneNumber}) async {
    EasyLoading.show(indicator: const CircularProgessApp());
    if (phoneNumber.substring(0, 3) != "+84") phoneNumber = "+84" + phoneNumber.substring(1);
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential).whenComplete(() async {
            await _saveUserInDatabase();
            HiveHelper.saveIsFirstLogin(false);
            snackBar(message: "phone_number_automatically_verified".tr);
            Get.offAllNamed(Routes.customerNavigation);
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
          Get.toNamed(Routes.otpVerification, arguments: [phoneNumber, 1]);
          EasyLoading.dismiss();
        },
      );
    } catch (e) {
      snackBar(message: "failed_to_verify_phone_number".tr);
    }
  }

  _saveUserInDatabase() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(_auth.currentUser!.uid)
        .set({"user_name": _auth.currentUser!.displayName, "avaURL": _auth.currentUser!.photoURL, "phone_number": _auth.currentUser!.phoneNumber});
  }

  Future<void> signOUt() async {
    print("Sign Out");
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.login);
  }
}
