import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String _boxAppKey = "setting";
  static const String _darkModeKey = "darkMode";
  static const String _isFirstLoginKey = "isFirstLogin";
  static const String _langeuageKey = "language";
  static const String _currentStoreKey = "currentStoreID";
  static const String _isPartnerKey = "isPartner";
  static final _boxApp = Hive.box(_boxAppKey);

   static initHive() async {
    //command line
    //flutter pub run build_runner build
    await  Hive.initFlutter();
    await Hive.openBox(_boxAppKey);
  }

  // static Future<void> addUser(UserModel userObj) async {
  //   return await boxApp.put(keyUser, userObj);
  // }

  static bool get getThemeMode  => _boxApp.get(_darkModeKey, defaultValue:false);

   static  saveThemeModeInMemory(bool isDarkMode)  {
    return  _boxApp.put(_darkModeKey, isDarkMode);
  }

  static bool get isFirstLogin  => _boxApp.get(_isFirstLoginKey, defaultValue:true);

   static  saveIsFirstLogin(bool isFirstLogin)  {
    return  _boxApp.put(_isFirstLoginKey, isFirstLogin);
  }

  static String get currentStoreID  => _boxApp.get(_currentStoreKey, defaultValue: "");

   static  saveCurrentStoreID(String currentStoreID)  {
    return  _boxApp.put(_currentStoreKey, currentStoreID);
  }

   static bool get isPartner  => _boxApp.get(_isPartnerKey, defaultValue: false);

   static  saveIsPartner(bool isPartner)  {
    return  _boxApp.put(_isPartnerKey, isPartner);
  }


  // static  deleteKeyUser() async {
  //    boxApp.delete(keyUser);
  // }
  // // static Future<void> setIsLogin(bool value) async {
  // //   return await boxApp.put(keyIsLogin, value);
  // // }
  // //
  // // static Future<bool> getIsLogin() async {
  // //   return await boxApp.get(keyIsLogin, defaultValue: false);
  // // }

  // Future<void> saveListString(List<String> data) async {
  //   return await boxApp.put(keyListString, data);
  // }

  // Future<List<String>> getListString() async {
  //   final List<dynamic> list =
  //       await boxApp.get(keyListString, defaultValue: []);
  //   if (list.isEmpty) {
  //     return [];
  //   } else {
  //     return list.cast<String>();
  //   }
  // }
}
