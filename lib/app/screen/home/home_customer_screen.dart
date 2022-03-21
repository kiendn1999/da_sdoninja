// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_radius.dart';
import 'package:da_sdoninja/app/constant/theme/app_shadows.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/honme_custom_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/dropdown_button.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:marquee/marquee.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/repository/user_info.dart';

class HomeCustomerScreen extends StatefulWidget {
  @override
  State<HomeCustomerScreen> createState() => _HomeCustomerScreenState();
}

class _HomeCustomerScreenState extends State<HomeCustomerScreen> {
  final _homeCustomerController = Get.find<HomeCustomerController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _homeCustomerController.getCurrentPosition();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            _filterTool(
              itemList: storeTypes,
              lable: "question_tus".tr,
              marginTop: 12.h,
              widthDropDownButton: 190.w,
              value: _homeCustomerController.dropdownDeviceValue,
              onChanged: (newValue) {
                _homeCustomerController.dropdownDeviceValue = newValue!;
                _homeCustomerController.getAllStore();
              },
            ),
            _searchStoreTextField(),
            _filterTool(
              itemList: sortTypes,
              lable: "recommended_shops".tr,
              widthDropDownButton: 147.w,
              marginTop: 17.h,
              value: _homeCustomerController.dropdownSortValue,
              onChanged: (newValue) {
                _homeCustomerController.dropdownSortValue = newValue!;
                _homeCustomerController.getAllStore();
              },
            ),
            _shopsListView(),
          ],
        ),
      ),
    );
  }

  Expanded _shopsListView() => Expanded(
        child: Obx(() => Align(
              alignment: Alignment.topCenter,
              child: Skeleton(
                isLoading: _homeCustomerController.stores.isEmpty,
                skeleton: SkeletonListView(),
                child: Container(
                  margin: EdgeInsets.only(top: 17.h),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => SizedBox(
                      height: 7.h,
                    ),
                    itemCount: _homeCustomerController.stores.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _shopsItem(index);
                    },
                  ),
                ),
              ),
            )),
      );

  _shopsItem(int index) => AppShadow.lightShadow(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius15)),
          child: InkWell(
            onTap: () => Get.toNamed(
              Routes.storeDetail,
              arguments: _homeCustomerController.stores[index].id,
            ),
            borderRadius: BorderRadius.circular(AppRadius.radius15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.radius15),
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Row(
                  children: [_shopsAvatar(index), Expanded(child: _shopInfo(index))],
                ),
              ),
            ),
          ),
        ),
      );

  Container _shopInfo(int index) => Container(
        margin: EdgeInsets.only(left: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_shopName(index), _shopRating(index), _shopDistance(index), _buttonRow(index)],
        ),
      );

  Container _buttonRow(int index) => Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buttonWithRadius10(
                onPressed: () {
                  if (_homeCustomerController.checkIsOpenStore(index)) if (UserCurrentInfo.phoneNumber != null)
                    _showHelpDialog(index);
                  else
                    _showDialogCheckHavePhoneNumber();
                },
                color: !_homeCustomerController.checkIsOpenStore(index) ? AppColors.black4 : AppColors.orange,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Text(
                  "help_me".tr,
                  style: AppTextStyle.tex18Bold(),
                )),
            buttonWithRadius10(
                onPressed: () => MapsLauncher.launchQuery(_homeCustomerController.stores[index].address!),
                color: AppColors.green,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Text(
                  "direct".tr,
                  style: AppTextStyle.tex18Bold(),
                ))
          ],
        ),
      );

  Future<Object?> _showHelpDialog(int index) {
    return showAnimatedDialog(
      context: Get.context!,
      animationType: DialogTransitionType.slideFromTopFade,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialogWidget(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            minWidth: 400,
            elevation: 7,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Transform.rotate(
                    angle: 180 * math.pi / 320,
                    child: SvgPicture.asset(
                      AppImages.icCall.getSVGImageAssets,
                      width: 40.w,
                      height: 40.h,
                      color: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
                    ),
                  ),
                  title: Text(
                    "call_the_shop".tr,
                    style: AppTextStyle.tex18Regular(),
                  ),
                  onTap: () {
                    launch("tel://${_homeCustomerController.stores[index].phoneNumber}");
                    Get.back();
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  child: ListTile(
                    leading: Image.asset(
                      AppImages.icHelp.getPNGImageAssets,
                      width: 40.w,
                      height: 40.h,
                      color: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
                    ),
                    title: Text(
                      "submit_a_help_request".tr,
                      style: AppTextStyle.tex18Regular(),
                    ),
                    onTap: () async => await _homeCustomerController.handleSendNotification(_homeCustomerController.stores[index], _homeCustomerController.address),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius10)));
      },
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<Object?> _showDialogCheckHavePhoneNumber() {
    return showAnimatedDialog(
      context: Get.context!,
      animationType: DialogTransitionType.slideFromTopFade,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'you_need_to_add_a_phone_number'.tr,
            style: AppTextStyle.tex18Regular(),
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "not_now".tr,
                  style: AppTextStyle.tex16Medium(),
                )),
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(Routes.profile);
                },
                child: Text("add_phone_number".tr, style: AppTextStyle.tex16Medium())),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius10)),
          titlePadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.symmetric(horizontal: 35.w),
          elevation: 7,
        );
      },
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  Container _shopDistance(int index) => Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.icDistance.getSVGImageAssets,
              width: 22.w,
              height: 22.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 8.w),
              child: Text(
                "${_homeCustomerController.stores[index].distance} km",
                style: AppTextStyle.tex18Regular(),
              ),
            )
          ],
        ),
      );

  Container _shopRating(int index) => Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.icStarSelected.getSVGImageAssets,
              width: 22.w,
              height: 22.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 8.w),
              child: Text(
                _homeCustomerController.stores[index].rating == 0
                    ? "not_yet".tr
                    : "${_homeCustomerController.stores[index].rating} (${_homeCustomerController.stores[index].ratingQuantity})",
                style: AppTextStyle.tex18Regular(),
              ),
            )
          ],
        ),
      );

  _shopName(int index) => AutoSizeText(
        _homeCustomerController.stores[index].storeName!,
        maxLines: 1,
        minFontSize: 20,
        style: AppTextStyle.tex18Regular(),
        overflowReplacement: SizedBox(
          height: 25.h,
          child: Marquee(
            text: _homeCustomerController.stores[index].storeName!,
            scrollAxis: Axis.horizontal,
            blankSpace: 10.0,
            velocity: 100.0,
            style: AppTextStyle.tex18Regular(),
            pauseAfterRound: const Duration(seconds: 1),
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
      );

  Stack _shopsAvatar(int index) {
    return Stack(
      children: [
        FadeInImage.assetNetwork(
            width: 120.w,
            height: 145.h,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  AppImages.imageAvaShopDefault.getPNGImageAssets,
                  fit: BoxFit.cover,
                  width: 120.h,
                  height: 145.h,
                ),
            placeholder: AppImages.imageAvaShopDefault.getPNGImageAssets,
            image: _homeCustomerController.stores[index].avaUrl!),
        Visibility(
          visible: !_homeCustomerController.checkIsOpenStore(index),
          child: Container(
            width: 120.w,
            height: 145.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.radius10), bottomLeft: Radius.circular(AppRadius.radius10)),
                color: AppColors.black.withOpacity(0.55)),
            child: Center(
              child: Text("temporarily_closed".tr, style: AppTextStyle.tex16Regular(color: AppColors.white), textAlign: TextAlign.center),
            ),
          ),
        )
      ],
    );
  }

  Widget _searchStoreTextField() => Builder(
    builder: (context) {
      return textFormFieldApp(
            marginTop: 17.h,
            contentPadding: EdgeInsets.only(top: 13.h, bottom: 13.h, left: 26.w),
            hintText: "enter_name_to_search".tr,
            style: AppTextStyle.tex17Regular(),
            iconHeight: 23.h,
            textAlign: TextAlign.center,
            controller: _homeCustomerController.storeNameTextFieldController,
            radius: AppRadius.radius90,
            suffixIcon: Container(
              margin: EdgeInsets.only(right: 26.w, left: 15.w),
              child: SvgPicture.asset(
                AppImages.icSearch.getSVGImageAssets,
                color: context.isDarkMode ? AppColors.white : AppColors.black,
                width: 23.w,
                height: 23.h,
              ),
            ),
            onChanged: (p0) {
              _homeCustomerController.getAllStore();
            },
          );
    }
  );

  Widget _filterTool(
          {required String lable, double marginTop = 0, required List<String> itemList, required double widthDropDownButton, String? value, void Function(String?)? onChanged}) =>
      Container(
        margin: EdgeInsets.only(top: marginTop),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                lable,
                style: AppTextStyle.tex18Regular(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40.w),
              child: dropDownButton(
                width: widthDropDownButton,
                itemList: itemList,
                contentPaddingHorizontal: 20.w,
                menuMaxHeight: 250.h,
                contentPaddingVertical: 7.h,
                value: value,
                onChanged: onChanged,
              ),
            )
          ],
        ),
      );
}
