import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_radius.dart';
import 'package:da_sdoninja/app/constant/app_shadows.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
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
    Builder(
        builder: (context) => AppShadow.lightShadow(
              child: Container(
                  width: width,
                  margin: EdgeInsets.only(top: marginTop),
                  child: Card(
                    elevation: 0,
                      margin: const EdgeInsets.all(0.65),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius10)),
                    child: DropdownButtonFormField(
                      style: AppTextStyle.tex18Regular(color: Get.isDarkMode ? AppColors.white : AppColors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingHorizontal, vertical: contentPaddingVertical),
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
                            value,
                          ),
                        );
                      }).toList(),
                    ),
                  )),
            ));

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
