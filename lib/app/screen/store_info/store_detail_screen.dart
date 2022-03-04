import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/store_detail_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/review_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/theme/app_radius.dart';
import '../../controller/page_controller/customer/customer_review_controller.dart';
import '../../controller/page_controller/customer/honme_custom_controller.dart';

class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final _storeDetailController = Get.find<StoreDetailController>();
  final CustomerReviewController _customerReviewController = Get.find();
  final _homeCustomerController = Get.find<HomeCustomerController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _storeDetailController.getInfoStore(Get.arguments);
    _customerReviewController.storeID = Get.arguments;
    _customerReviewController.getAllReview();
    _customerReviewController.getAllStatis();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        endDrawer: DrawerApp(),
        appBar: appBarTransparent(backIconButtonColor: AppColors.white, primaryBackButtonColor: AppColors.black.withOpacity(0.25)),
        body: Obx(() => _storeDetailController.store.value.id == null
            ? Center(
                child: Image.asset(
                  AppImages.imageLoad.getGIFImageAssets,
                  width: Get.width,
                  height: 400.h,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [_shopImageAva(), _infoShop(context)],
                ),
              )),
        bottomNavigationBar: Obx(() => _storeDetailController.store.value.id != null
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buttonBottomBar(
                      onPressed: () {
                        if (_storeDetailController.checkIsOpenStore()) _showHelpDialog();
                      },
                      title: "help_me".tr,
                      color: !_storeDetailController.checkIsOpenStore() ? AppColors.black4 : AppColors.orange,
                    ),
                    _buttonBottomBar(onPressed: () {}, title: "chat".tr, color: AppColors.blue2),
                    _buttonBottomBar(
                        onPressed: () async => await _storeDetailController.shareStoreInfo(),
                        title: "share".tr,
                        color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor),
                  ],
                ),
              )
            : const SizedBox.shrink()),
      ),
    );
  }

  Future<Object?> _showHelpDialog() {
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
                    launch("tel://${_storeDetailController.store.value.phoneNumber}");
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
                    onTap: () async => await _homeCustomerController.handleSendNotification(_storeDetailController.store.value, _homeCustomerController.address),
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

  Widget _buttonBottomBar({required void Function() onPressed, required String title, Color? color}) {
    return buttonWithRadius10(
        onPressed: onPressed,
        child: Text(
          title,
          style: AppTextStyle.tex18Bold(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 15.h),
        color: color);
  }

  Widget _infoShop(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _notifiClosed(),
          _shopName(),
          _listTileWithIconLeading(
              pathImage: AppImages.icStarSelected,
              title: _storeDetailController.store.value.rating == 0
                  ? "not_yet".tr
                  : "${_storeDetailController.store.value.rating} (${_storeDetailController.store.value.ratingQuantity})"),
          _distanceAddress(),
          Visibility(
            visible: _storeDetailController.store.value.storeServices.contains("on_site_repair"),
            child: _listTileWithCheckBoxLeading(
                value: _storeDetailController.store.value.storeServices.contains("on_site_repair"), context: context, title: "on_site_repair".tr, onChanged: (value) {}),
          ),
          Visibility(
              visible: _storeDetailController.store.value.storeServices.contains("delivery"),
              child: _listTileWithCheckBoxLeading(
                  value: _storeDetailController.store.value.storeServices.contains("delivery"), context: context, title: "delivery".tr, onChanged: (value) {})),
          _listTileWithIconLeading(
              pathImage: AppImages.icClockSelected,
              title: "open_time".trParams({
                "start": _storeDetailController.store.value.openTime!,
                "end": _storeDetailController.store.value.closingTime!,
              }),
              iconColor: AppColors.orange),
          _listTileWithIconLeading(
              pathImage: AppImages.icStoreSelected, title: "introduce".tr, iconColor: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor),
          _introduceContent(),
          Visibility(
            visible: _storeDetailController.store.value.rating == null ? false : true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ratingReviewsCount(),
                _rating(),
                Obx(
                  () => _customerReviewController.listOfListReview.isEmpty
                      ? Image.asset(
                          AppImages.imageLoad.getGIFImageAssets,
                          width: Get.width,
                          height: 400.h,
                        )
                      : ReviewList(
                          reviews: _customerReviewController.listOfListReview[0],
                          itemCount: _customerReviewController.listOfListReview[0].length < 3 ? _customerReviewController.listOfListReview[0].length : 2,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 12.h),
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _rating() {
    return Container(
      margin: EdgeInsets.only(top: 7.h),
      child: Row(
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(text: "${_storeDetailController.store.value.rating}", style: AppTextStyle.tex17Bold()),
            TextSpan(text: "/5", style: AppTextStyle.tex15Bold()),
          ])),
          Container(
            margin: EdgeInsets.only(left: 7.w),
            child: SvgPicture.asset(
              AppImages.icStarSelected.getSVGImageAssets,
              width: 17.w,
              height: 17.h,
            ),
          )
        ],
      ),
    );
  }

  Widget _ratingReviewsCount() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(text: "rating_reviews".tr, style: AppTextStyle.tex18Medium()),
            TextSpan(text: " (${_storeDetailController.store.value.ratingQuantity})", style: AppTextStyle.tex16Medium()),
          ])),
          TextButton(
              onPressed: () => Get.toNamed(Routes.customerReview),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
              child: Row(
                children: [
                  Text(
                    "view_all".tr,
                    style: AppTextStyle.tex17Regular(),
                  ),
                  SizedBox(
                    width: 14.w,
                    child: const Icon(
                      Icons.navigate_next_sharp,
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Container _introduceContent() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: Text(
        "\t ${_storeDetailController.store.value.introduce}",
        style: AppTextStyle.tex18Regular(),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Container _distanceAddress() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _listTileWithIconLeading(marginTop: 0, pathImage: AppImages.icDistance, title: "${_storeDetailController.distance.value} km"),
          SizedBox(
            width: 200.w,
            child: Text(
              _storeDetailController.store.value.address!,
              style: AppTextStyle.tex18Regular(),
            ),
          ),
          GestureDetector(
            onTap: () => MapsLauncher.launchQuery(_storeDetailController.store.value.address!),
            child: SvgPicture.asset(
              AppImages.icDirect.getSVGImageAssets,
              width: 33.w,
              height: 33.h,
            ),
          ),
        ],
      ),
    );
  }

  _shopName() {
    return AutoSizeText(
      _storeDetailController.store.value.storeName!.toUpperCase(),
      maxLines: 1,
      minFontSize: 20,
      style: AppTextStyle.tex18Regular(),
      overflowReplacement: SizedBox(
        height: 25.h,
        child: Marquee(
          text: _storeDetailController.store.value.storeName!,
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
  }

  Visibility _notifiClosed() {
    return Visibility(
        visible: !_storeDetailController.checkIsOpenStore(),
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Text(
            "closed_store_nontifi".tr,
            style: AppTextStyle.tex18Medium(color: AppColors.red),
            textAlign: TextAlign.justify,
          ),
        ));
  }

  Widget _listTileWithIconLeading({required String pathImage, required String title, Color? iconColor, double marginTop = 12}) {
    return Container(
      margin: EdgeInsets.only(top: marginTop.h),
      child: Row(
        children: [
          SvgPicture.asset(
            pathImage.getSVGImageAssets,
            width: 22.w,
            height: 22.h,
            color: iconColor,
          ),
          Container(
              margin: EdgeInsets.only(left: 10.h),
              child: Text(
                title,
                style: AppTextStyle.tex18Regular(),
              ))
        ],
      ),
    );
  }

  Widget _listTileWithCheckBoxLeading({required bool? value, required String title, required void Function(bool?)? onChanged, required BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.h,
            child: Checkbox(
              value: value,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
              onChanged: onChanged,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 10.h),
              child: Text(
                title,
                style: AppTextStyle.tex18Regular(),
              ))
        ],
      ),
    );
  }

  FadeInImage _shopImageAva() {
    return FadeInImage.assetNetwork(
        width: Get.width,
        height: 200.h,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) => Image.asset(
              AppImages.imageAvaShopDefault.getPNGImageAssets,
              fit: BoxFit.cover,
              width: Get.width,
              height: 200.h,
            ),
        placeholder: AppImages.imageAvaShopDefault.getPNGImageAssets,
        image: _storeDetailController.store.value.avaUrl!);
  }
}
