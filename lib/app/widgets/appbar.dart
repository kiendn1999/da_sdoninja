import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

AppBar appBarTransparent({Widget? title, Color? backIconButtonColor, Color? primaryBackButtonColor}) => AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      title: ElevatedButton(
        onPressed: () => Get.back(),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20.w,
          color: backIconButtonColor,
        ),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            elevation: 7,
            primary: primaryBackButtonColor,
            padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 19.h),
            visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      ),
    );

AppBar appBarPopular({bool? centerTitle, double? titleSpacing, Widget? title, List<Widget>? actions}) {
  return AppBar(
    leading: IconButton(
      icon: Transform.scale(
        scale: 1.h,
        child: const Icon(
          Icons.arrow_back_ios,
          size: 23,
        ),
      ),
      onPressed: () => Get.back(),
    ),
    title: title,
    toolbarHeight: 50.h,
    titleTextStyle: AppTextStyle.tex20Regular(),
    toolbarTextStyle: AppTextStyle.tex20Regular(),
    centerTitle: centerTitle,
    titleSpacing: titleSpacing,
    actions: actions,
  );
}
