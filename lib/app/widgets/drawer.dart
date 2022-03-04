import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/constant/theme/app_theme.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/authen_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/data/hive/hive_helper.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../constant/theme/app_radius.dart';

class DrawerApp extends StatelessWidget {
  final _authenController = Get.find<AuthController>();
  final _profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Apptheme.lightTheme.copyWith(canvasColor: (context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor).withOpacity(0.70)),
      child: SizedBox(
        width: 250.w,
        child: Drawer(
          child: Column(
            children: [
              _header(),
              ListView(
                shrinkWrap: true,
                children: [
                  _listTile(
                    leading: AppImages.icSearch,
                    title: "search_repair_shop".tr,
                    onTap: () {
                      HiveHelper.saveIsPartner(false);
                      Get.offAllNamed(Routes.customerNavigation);
                    },
                  ),
                  _listTile(
                      leading: AppImages.icStore,
                      title: "my_repair_shop".tr,
                      onTap: () {
                        HiveHelper.saveIsPartner(true);
                        Get.offAllNamed(Routes.partnerNavigation);
                      }),
                  _listTile(leading: AppImages.icGlobe, title: "language".tr, onTap: () => _showHelpDialog()),
                  _listTile(
                      leading: AppImages.icMoon,
                      title: "dark_mode".tr,
                      trailing: Transform.scale(
                          scale: 1.h,
                          child: Switch(
                              value: context.isDarkMode,
                              activeColor: AppColors.primaryDarkModeColor,
                              activeTrackColor: AppColors.white4,
                              onChanged: (value) {
                                Get.changeTheme(value ? Apptheme.darkTheme : Apptheme.lightTheme);
                                HiveHelper.saveThemeModeInMemory(value);
                              }))),
                  _listTile(leading: AppImages.icLogOut, title: "log_out".tr, onTap: () async => await _authenController.signOUt()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Object?> _showHelpDialog() {
    return showAnimatedDialog(
      context: Get.context!,
      animationType: DialogTransitionType.slideFromTopFade,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ValueListenableBuilder(
            valueListenable: Hive.box('setting').listenable(),
            builder: (context, box, widget) => CustomDialogWidget(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                minWidth: 400,
                elevation: 7,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<String>(
                      title: Text('vietnamese'.tr),
                      value: 'vi',
                      groupValue: HiveHelper.languageCode,
                      onChanged: (value) {
                        Get.updateLocale(Locale(value!));
                        HiveHelper.saveLanguageCode(value);
                        Get.back();
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('english'.tr),
                      value: 'en',
                      groupValue: HiveHelper.languageCode,
                      onChanged: (value) {
                        Get.updateLocale(Locale(value!));
                        HiveHelper.saveLanguageCode(value);
                        Get.back();
                      },
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius10))));
      },
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  ListTile _listTile({required String leading, required String title, Widget? trailing, void Function()? onTap}) {
    return ListTile(
        leading: SvgPicture.asset(
          leading.getSVGImageAssets,
          height: 22.h,
          width: 22.w,
          color: AppColors.white,
        ),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        contentPadding: EdgeInsets.only(top: 20.h, left: 20.w),
        minLeadingWidth: 0,
        horizontalTitleGap: 10.w,
        onTap: onTap,
        title: Text(
          title,
          style: AppTextStyle.tex18Regular(color: AppColors.white),
        ),
        trailing: trailing);
  }

  Container _header() {
    return Container(
      margin: EdgeInsets.only(top: 20.h, right: 20.w, left: 25.w),
      child: Column(
        children: [_nameAndAva(), _divider()],
      ),
    );
  }

  Container _divider() {
    return Container(
      margin: EdgeInsets.only(top: 25.h),
      child: const Divider(
        height: 0,
        thickness: 2,
        color: AppColors.white,
      ),
    );
  }

  GestureDetector _nameAndAva() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.profile),
      child: Obx(() => Column(
            children: [
              ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: AppImages.imageDefautAvatar.getPNGImageAssets,
                  image: "${_profileController.avaURL}",
                  imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                    AppImages.imageDefautAvatar.getPNGImageAssets,
                    fit: BoxFit.cover,
                    width: 100.h,
                    height: 100.h,
                  ),
                  fit: BoxFit.cover,
                  width: 100.h,
                  height: 100.h,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 17.h),
                child: Text(
                  _profileController.displayName ?? "no_name".tr,
                  style: AppTextStyle.tex20Medium(color: AppColors.white),
                ),
              ),
            ],
          )),
    );
  }
}
