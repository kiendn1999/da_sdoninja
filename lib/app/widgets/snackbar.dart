import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

snackBar({required String message}) {
  return Get.rawSnackbar(
      messageText: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.justify,
            style: AppTextStyle.tex14Regular(color: AppColors.white),
          ),
        ),
        color: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
      ),
      duration: const Duration(seconds: 5),
      padding: EdgeInsets.zero);
}
