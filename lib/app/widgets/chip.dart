import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_shadows.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/function_controller/review_chip_controller.dart';
import 'package:da_sdoninja/app/controller/function_controller/text_chip_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
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
      child: Row(
          children: List.generate(
              ratingTypes.length,
              (index) => Container(
                    margin: EdgeInsets.only(right: 15.w),
                    child: AppShadow.lightShadow(
                      child: Obx(() => ChoiceChip(
                            label: ratingTypes[index] == 6
                                ? Text("all".trParams({"count": "${_reviewChipController.getRatingTypeCount(ratingTypes[index])}"}))
                                : Row(
                                    children: [
                                      Text("${ratingTypes[index]}"),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                                        child: SvgPicture.asset(
                                          AppImages.icStarSelected.getSVGImageAssets,
                                          width: 17.w,
                                          height: 17.h,
                                        ),
                                      ),
                                      Text("(${_reviewChipController.getRatingTypeCount(ratingTypes[index])})")
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
                          )),
                    ),
                  ))
          /* [
        for (int index = 5; index >= 0; index--)
          Container(
            margin: EdgeInsets.only(right: 15.w),
            child: AppShadow.lightShadow(
              child: Obx(() => ChoiceChip(
                    label: index == 5
                        ? Text("all".trParams({"count": "${reviewCountList[index]}"}))
                        : Row(
                            children: [
                              Text("${(index + 1)}"),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                child: SvgPicture.asset(
                                  AppImages.icStarSelected.getSVGImageAssets,
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
                  )),
            ),
          )
      ] */
          ),
    );
  }
}

class TextChipChoice extends StatelessWidget {
  final TextChipController _textChipController;
  TextChipChoice(this._textChipController);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: ListView.separated(
        itemCount: stageList.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        separatorBuilder: (context, index) => SizedBox(
          width: 23.w,
        ),
        itemBuilder: (context, index) {
          return Obx(() => InkWell(
                onTap: () {
                  _textChipController.currentIndex = index;
                  _textChipController.pageController.animateToPage(
                    _textChipController.currentIndex,
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
                    stageList[index].tr,
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
