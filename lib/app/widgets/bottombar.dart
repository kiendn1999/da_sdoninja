import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/data/model/item_bottombar_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Widget bottomBarHomeScreen(
        {required List<ItemBottomBar> items,
        required int currentIndex,
        required void Function(int) onTap}) =>
    Builder(
        builder: (context) => SizedBox(
              height: 70.h,
              child: BottomNavigationBar(
                  onTap: onTap,
                  currentIndex: currentIndex,
                  type: BottomNavigationBarType.shifting,
                  selectedFontSize: 14.sp,
                  items: List.generate(items.length, (index) => BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                           items[index].pathIconUnSelected.getSVGImageAssets,
                            width: 35.w,
                            height: 35.h,
                            color: context.isDarkMode
                                ? AppColors.primaryDarkModeColor
                                : AppColors.primaryLightModeColor,
                          ),
                          activeIcon: SvgPicture.asset(
                                                          items[index].pathIconSelected.getSVGImageAssets,
                            width: 35.w,
                            height: 35.h,
                            color: context.isDarkMode
                                ? AppColors.primaryDarkModeColor
                                : AppColors.primaryLightModeColor,
                          ),
                          label: items[index].lable))
                  ),
            ));
