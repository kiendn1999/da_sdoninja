import 'package:da_sdoninja/app/data/hive/hive_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/bindings/common/initial_binding.dart';
import 'app/constant/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/translations/app_translations.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveHelper.initHive();
  runApp(SdoNinjaApp());
}

class SdoNinjaApp extends StatelessWidget {
  SdoNinjaApp({Key? key}) : super(key: key);
  late StreamSubscription<User?> _sub;
  final FirebaseAuth _auth = FirebaseAuth.instance;
//Kiennnn
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 826),
        splitScreenMode: false,
        builder: () => GetMaterialApp(
              title: "SDONINJA",
              initialRoute: _initRoute(),
              initialBinding: InitialBinding(),
              theme: HiveHelper.getThemeMode ? Apptheme.darkTheme : Apptheme.lightTheme,
              darkTheme: Apptheme.darkTheme,
              onDispose: _dispose,
              debugShowCheckedModeBanner: false,
              defaultTransition: Transition.rightToLeft,
              getPages: AppPages.pages,
              builder: EasyLoading.init(),
              locale: const Locale('vi'),
              translationsKeys: AppTranslation.translations,
            ));
  }

  String _initRoute() {
    return _auth.currentUser == null ? (HiveHelper.isFirstLogin ? Routes.introduce : Routes.login) : Routes.customerNavigation;
  }

  void _dispose() {
    Hive.close();
    _sub.cancel();
  }
}
