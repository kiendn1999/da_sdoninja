import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';

class AppButtonTheme {
  static final elevatedButtonPrimaryLightTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          primary: AppColors.primaryLightModeColor,
          textStyle: const TextStyle(color: AppColors.white),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius10))));
  static final elevatedButtonPrimaryDarkTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          primary: AppColors.primaryDarkModeColor,
          textStyle: const TextStyle(color: AppColors.white),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius10))));

  static final outlineButtonPrimaryLightTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          primary: AppColors.black,
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.primaryLightModeColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radius10),
          )));

  static final outlineButtonPrimaryDarkTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          primary: AppColors.white,
          backgroundColor: AppColors.black1,
          side: const BorderSide(color: AppColors.primaryDarkModeColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radius10),
          )));
}
