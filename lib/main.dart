import 'package:da_sdoninja/app/bindings/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/constant/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/translations/app_translations.dart';

void main() {
  runApp(const SdoNinjaApp());
}

class SdoNinjaApp extends StatelessWidget {
  const SdoNinjaApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 826),
        splitScreenMode: false,
        builder: () => GetMaterialApp(
              title: "SDONINJA",
              initialRoute: Routes.introduce,
              initialBinding: InitialBinding(),
              theme: Apptheme.lightTheme,
              darkTheme: Apptheme.darkTheme,
              debugShowCheckedModeBanner: false,
              defaultTransition: Transition.rightToLeft,
              getPages: AppPages.pages,
              locale: const Locale('vi'),
              translationsKeys: AppTranslation.translations,
            ));
  }
}
