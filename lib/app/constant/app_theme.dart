import 'package:da_sdoninja/app/constant/app_button_theme.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class Apptheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(color: AppColors.primaryLightModeColor),
      elevatedButtonTheme: AppButtonTheme.elevatedButtonPrimaryLightTheme,
      outlinedButtonTheme: AppButtonTheme.outlineButtonPrimaryLightTheme,

      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(AppColors.primaryLightModeColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primaryLightModeColor),
      timePickerTheme: const TimePickerThemeData(
          dialHandColor: AppColors.primaryLightModeColor,
          entryModeIconColor: AppColors.primaryLightModeColor,
          hourMinuteTextColor: AppColors.primaryLightModeColor,
          dayPeriodTextColor: AppColors.primaryLightModeColor),
      textTheme: AppTextStyle.textFontApp,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryLightModeColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          isDense: true,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryLightModeColor)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryLightModeColor))));

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(color: AppColors.primaryDarkModeColor),
      elevatedButtonTheme: AppButtonTheme.elevatedButtonPrimaryDarkTheme,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(AppColors.primaryDarkModeColor),
      ),
      timePickerTheme: const TimePickerThemeData(
          dialHandColor: AppColors.primaryDarkModeColor,
          entryModeIconColor: AppColors.primaryDarkModeColor,
          hourMinuteTextColor: AppColors.primaryDarkModeColor,
          dayPeriodTextColor: AppColors.primaryDarkModeColor),
      outlinedButtonTheme: AppButtonTheme.outlineButtonPrimaryDarkTheme,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primaryDarkModeColor),
      textTheme: AppTextStyle.textFontApp.apply(displayColor: AppColors.white, bodyColor: AppColors.white),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryDarkModeColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.black1,
          isDense: true,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryDarkModeColor)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryDarkModeColor))));
}
