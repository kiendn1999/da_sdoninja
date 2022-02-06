import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget textFormFieldApp(
        {String? hintText,
        EdgeInsetsGeometry? contentPadding,
        double marginTop = 0,
        Widget? suffixIcon,
        double radius = 10,
        TextEditingController? controller,
        void Function(String?)? onSaved,
        int maxLines = 1,
        double iconHeight = 0.0,
        String? initialValue,
        TextAlign textAlign = TextAlign.start,
        TextStyle? style,
        TextStyle? errorStyle,
        void Function(String)? onChanged,
        TextInputType? keyboardType,
        String? Function(String?)? validator}) =>
    Container(
      margin: EdgeInsets.only(top: marginTop),
      child: TextFormField(
        textAlign: textAlign,
        validator: validator,
        onSaved: onSaved,
        controller: controller,
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: maxLines,
        style: style,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor)),
          hintText: hintText,
          suffixIconConstraints: BoxConstraints(minHeight: iconHeight),
          suffixIcon: suffixIcon,
          errorStyle: errorStyle,
          hintStyle: style,
          contentPadding: contentPadding,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor)),
        ),
      ),
    );
