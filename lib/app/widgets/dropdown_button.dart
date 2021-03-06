import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_radius.dart';
import 'package:da_sdoninja/app/constant/theme/app_shadows.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dropDownButton(
        {required double width,
        double contentPaddingHorizontal = 0,
        double contentPaddingVertical = 0,
        String? value,
        double marginTop = 0.0,
        double? menuMaxHeight,
        void Function(String?)? onChanged,
        required List<String> itemList}) =>
    AppShadow.lightShadow(
      child: Builder(
        builder: (context) {
          return Container(
              width: width,
              margin: EdgeInsets.only(top: marginTop),
              child: DropdownButtonFormField(
                style: AppTextStyle.tex18Regular(color: context.isDarkMode ? AppColors.white : AppColors.black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingHorizontal, vertical: contentPaddingVertical),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor),
                        borderRadius: BorderRadius.circular(AppRadius.radius10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor),
                        borderRadius: BorderRadius.circular(AppRadius.radius10))),
                isDense: true,
                onChanged: onChanged,
                isExpanded: true,
                value: value,
                alignment: AlignmentDirectional.bottomEnd,
                menuMaxHeight: menuMaxHeight,
                items: itemList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.tr,
                    ),
                  );
                }).toList(),
              ));
        }
      ),
    );

Widget dropDownButtonNoneUnderLine(
        {required double width,
        double contentPaddingHorizontal = 0,
        double contentPaddingVertical = 0,
        String? value,
        double marginTop = 0.0,
        double? menuMaxHeight,
        void Function(String?)? onChanged,
        required List<String> itemList}) =>
    DropdownButtonHideUnderline(
      child: DropdownButton(
        style: AppTextStyle.tex18Regular(color: Get.isDarkMode ? AppColors.white : AppColors.black),
        isDense: true,
        onChanged: onChanged,
        icon: const SizedBox.shrink(),
        // isExpanded: true,
        value: value,
        alignment: AlignmentDirectional.bottomEnd,
        menuMaxHeight: menuMaxHeight,
        items: itemList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
      ),
    );
