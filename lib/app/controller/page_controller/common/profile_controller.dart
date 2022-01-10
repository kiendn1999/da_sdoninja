import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  late final Rxn<User> _firebaseUser;

  String? get displayName => _firebaseUser.value?.displayName;
  String? get phoneNumber => _firebaseUser.value?.phoneNumber;
  String? get avaURL => _firebaseUser.value?.photoURL;

  updateProfile(String name) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    _firebaseUser = Rxn<User>(FirebaseAuth.instance.currentUser);
    _firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
    super.onInit();
  }
}
