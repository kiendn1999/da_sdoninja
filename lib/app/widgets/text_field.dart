import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget textFormFieldApp(
        {String? hintText,
        EdgeInsetsGeometry? contentPadding,
        double marginTop = 0,
        Widget? suffixIcon,
        double radius = 10,
        TextEditingController? controller,
        int? maxLines,
         int? minLines,
        double iconHeight = 0.0,
        TextAlign textAlign = TextAlign.start,
        TextStyle? style,
        TextInputType? keyboardType,
        String? Function(String?)? validator}) =>
    Builder(
      builder: (context) => Container(
        margin: EdgeInsets.only(top: marginTop),
        child: AppShadow.lightShadow(
            child: TextFormField(
          textAlign: textAlign,
          validator: validator,
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          style: style,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor)),
            hintText: hintText,
            suffixIconConstraints: BoxConstraints(minHeight: iconHeight),
            suffixIcon: suffixIcon,
          
            hintStyle: style,
            contentPadding: contentPadding,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor)),
          ),
        )),
      ),
    );
