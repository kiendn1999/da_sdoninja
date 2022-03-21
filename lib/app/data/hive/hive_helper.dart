import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String _boxAppKey = "setting";
  static const String _darkModeKey = "darkMode";
  static const String _isFirstLoginKey = "isFirstLogin";
  static const String _languageKey = "language";
  static const String _currentStoreKey = "currentStoreID";
  static const String _isPartnerKey = "isPartner";
  static final boxApp = Hive.box(_boxAppKey);

   static initHive() async {
    //command line
    //flutter pub run build_runner build
    await  Hive.initFlutter();
    await Hive.openBox(_boxAppKey);
  }

  // static Future<void> addUser(UserModel userObj) async {
  //   return await boxApp.put(keyUser, userObj);
  // }

  static bool get getThemeMode  => boxApp.get(_darkModeKey, defaultValue:false);

   static  saveThemeModeInMemory(bool isDarkMode)  {
    return  boxApp.put(_darkModeKey, isDarkMode);
  }

  static bool get isFirstLogin  => boxApp.get(_isFirstLoginKey, defaultValue:true);

   static  saveIsFirstLogin(bool isFirstLogin)  {
    return  boxApp.put(_isFirstLoginKey, isFirstLogin);
  }

  static String get currentStoreID  => boxApp.get(_currentStoreKey, defaultValue: "");

   static  saveCurrentStoreID(String currentStoreID)  {
    return  boxApp.put(_currentStoreKey, currentStoreID);
  }

   static String get languageCode  => boxApp.get(_languageKey, defaultValue: Get.deviceLocale?.languageCode);

   static  saveLanguageCode(String languageCode)  {
    return  boxApp.put(_languageKey, languageCode);
  }

   static bool get isPartner  => boxApp.get(_isPartnerKey, defaultValue: false);

   static  saveIsPartner(bool isPartner)  {
    return  boxApp.put(_isPartnerKey, isPartner);
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
