import 'dart:async';
import 'package:da_sdoninja/app/constant/string/key_id.dart';
import 'package:da_sdoninja/app/data/hive/hive_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app/bindings/common/initial_binding.dart';
import 'app/constant/theme/app_theme.dart';
import 'app/notifications/notificationservice.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveHelper.initHive();
  NotificationService().initNotification();
  runApp(SdoNinjaApp());
}

class SdoNinjaApp extends StatelessWidget {
  SdoNinjaApp({Key? key}) : super(key: key);
  late StreamSubscription<User?> _sub;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
              onInit: initState,
              locale: const Locale('vi'),
              translationsKeys: AppTranslation.translations,
            ));
  }

  Future<void> initState() async {
    await configOneSignel();
  }

  Future<void> configOneSignel() async {
    tz.initializeTimeZones();
    await OneSignal.shared.setAppId(oneSignalAppID);

    // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
    //   NotificationService().showNotification(1, "title", "body", 10);
    // });
    //  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
    //   NotificationService().showNotification(1, "title", "body", 10);
    // });

    OneSignal.shared.setLanguage("vi");

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
     // print('FOREGROUND HANDLER CALLED WITH: ${event}');

      /// Display Notification, send null to not display
      event.complete(null);
      NotificationService().showNotification(1, event.notification.title!, event.notification.body!, 10);
    });
  }

  String _initRoute() {
    return _auth.currentUser == null ? (HiveHelper.isFirstLogin ? Routes.introduce : Routes.login) : (HiveHelper.isPartner ? Routes.partnerNavigation : Routes.customerNavigation);
  }

  void _dispose() {
    Hive.close();
    _sub.cancel();
  }
}
