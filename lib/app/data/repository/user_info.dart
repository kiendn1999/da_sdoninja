import 'package:firebase_auth/firebase_auth.dart';

class UserCurrentInfo {
  static User? get  currentUser => FirebaseAuth.instance.currentUser;
  static String? get userID => FirebaseAuth.instance.currentUser?.uid;
  static String? get userName => FirebaseAuth.instance.currentUser?.displayName;
  static String? get avaURL => FirebaseAuth.instance.currentUser?.photoURL;
  static String? get phoneNumber => FirebaseAuth.instance.currentUser?.phoneNumber;
}
