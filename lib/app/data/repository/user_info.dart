import 'package:firebase_auth/firebase_auth.dart';

class UserCurrentInfo {
  static User? currentUser = FirebaseAuth.instance.currentUser;
  static String? userID = FirebaseAuth.instance.currentUser?.uid;
  static String? userName = FirebaseAuth.instance.currentUser?.displayName;
  static String? avaURL = FirebaseAuth.instance.currentUser?.photoURL;
  static String? phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
}
