import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_radius.dart';
import 'package:da_sdoninja/app/constant/app_shadows.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/function_controller/review_chip_controller.dart';
import 'package:da_sdoninja/app/controller/function_controller/text_chip_controller.dart';
import 'package:da_sdoninja/app/data/model/demo/review_model.dart';
import 'package:da_sdoninja/app/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ReviewChipChoice extends StatelessWidget {
  final ReviewChipController _reviewChipController;
  ReviewChipChoice(this._reviewChipController);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.w),
      child: Row(children: [
        for (int index = 5; index >= 0; index--)
          Container(
            margin: EdgeInsets.only(right: 15.w),
            child: AppShadow.lightShadow(
              child: Obx(() => Card(
                    elevation: 0,
                    margin: const EdgeInsets.all(0.65),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius90)),
                    child: ChoiceChip(
                      label: index == 5
                          ? Text("all".trParams({"count": reviewCountList[index].toString()}))
                          : Row(
                              children: [
                                Text((index + 1).toString()),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: SvgPicture.asset(
                                    StringUtils.getSVGImageAssets(AppImages.icStarSelected),
                                    width: 17.w,
                                    height: 17.h,
                                  ),
                                ),
                                Text("(${reviewCountList[index]})")
                              ],
                            ),
                      selected: index == _reviewChipController.currentIndex,
                      disabledColor: null,
                      selectedColor: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                      visualDensity: const VisualDensity(vertical: -4),
                      pressElevation: 0,
                      onSelected: (value) {
                        _reviewChipController.currentIndex = index;
                        _reviewChipController.pageController.animateToPage(
                          index,
                          duration: const Duration(
                            milliseconds: 200,
                          ),
                          curve: Curves.easeIn,
                        );
                      },
                      labelStyle: AppTextStyle.tex17Medium(color: _reviewChipController.currentIndex == index ? AppColors.white : null),
                      side: BorderSide(color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor, width: 2),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )),
            ),
          )
      ]),
    );
  }
}

class TextChipChoice extends StatelessWidget {
  final TextChipController _textChipController;
  TextChipChoice(this._textChipController);

  final List<String> _stageList = [
    "cancelled".tr,
    "checking".tr,
    "checked".tr,
    "waiting_to_fix".tr,
    "fixing".tr,
    "fixed".tr,
    "paid".tr,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: ListView.separated(
        itemCount: _stageList.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        separatorBuilder: (context, index) => SizedBox(
          width: 23.w,
        ),
        itemBuilder: (context, index) {
          return Obx(() => InkWell(
                onTap: () {
                  _textChipController.currentIndex = index;
                  _textChipController.pageController.animateToPage(
                    index,
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    curve: Curves.easeIn,
                  );
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      border: _textChipController.currentIndex == index
                          ? Border(
                              bottom: BorderSide(
                              color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
                              width: 2.0, // Underline thickness
                            ))
                          : null),
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _stageList[index],
                    style: _textChipController.currentIndex == index
                        ? AppTextStyle.tex18Bold(color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor)
                        : AppTextStyle.tex18Regular(),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
