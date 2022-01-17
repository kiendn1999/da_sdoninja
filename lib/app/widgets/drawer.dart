import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/constant/app_theme.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/authen_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/data/hive/hive_helper.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DrawerApp extends StatelessWidget {
  final _authenController = Get.find<AuthController>();
  final _profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Apptheme.lightTheme.copyWith(
          canvasColor: (context.isDarkMode
                  ? AppColors.primaryDarkModeColor
                  : AppColors.primaryLightModeColor)
              .withOpacity(0.70)),
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
                    onTap: () => Get.offAllNamed(Routes.customerNavigation),
                  ),
                  _listTile(
                      leading: AppImages.icStore,
                      title: "my_repair_shop".tr,
                      onTap: () => Get.offAllNamed(Routes.partnerNavigation)),
                  _listTile(leading: AppImages.icGlobe, title: "language".tr),
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
                                Get.changeTheme(value
                                    ? Apptheme.darkTheme
                                    : Apptheme.lightTheme);
                                HiveHelper.saveThemeModeInMemory(value);
                              }))),
                  _listTile(
                      leading: AppImages.icLogOut,
                      title: "log_out".tr,
                      onTap: () async => await _authenController.signOUt()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  ListTile _listTile(
      {required String leading,
      required String title,
      Widget? trailing,
      void Function()? onTap}) {
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
                  image: _profileController.avaURL.toString(),
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset(
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
                  _profileController.displayName??"no_name".tr,
                  style: AppTextStyle.tex20Medium(color: AppColors.white),
                ),
              ),
            ],
          )),
    );
  }
}
