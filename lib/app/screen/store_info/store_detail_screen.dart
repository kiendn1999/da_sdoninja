import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/data/model/demo/review_model.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/utils/string_utils.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/review_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StoreDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        endDrawer: const DrawerApp(),
        appBar: appBarTransparent(
            backIconButtonColor: AppColors.white,
            primaryBackButtonColor: AppColors.black.withOpacity(0.25)),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_shopImageAva(), _infoShop(context)],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buttonBottomBar(
                  onPressed: () {},
                  title: "help_me".tr,
                  color: AppColors.orange),
              _buttonBottomBar(
                  onPressed: () {}, title: "chat".tr, color: AppColors.blue2),
              _buttonBottomBar(
                  onPressed: () {},
                  title: "share".tr,
                  color: context.isDarkMode
                      ? AppColors.primaryDarkModeColor
                      : AppColors.primaryLightModeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonBottomBar(
      {required void Function() onPressed,
      required String title,
      Color? color}) {
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
          _nontifiClosed(),
          _shopName(),
          _listTileWithIconLeading(
              pathImage: AppImages.icStarSelected, title: "4.5 (25)"),
          _distanceAddress(),
          _listTileWithCheckBoxLeading(
              value: true,
              context: context,
              title: "on_site_repair".tr,
              onChanged: (value) {}),
          _listTileWithCheckBoxLeading(
              value: false,
              context: context,
              title: "delivery".tr,
              onChanged: (value) {}),
              _listTileWithIconLeading(
              pathImage: AppImages.icClockSelected,
              title: "open_time".trParams({
                "start":"7:00 AM",
                "end":"5:00 PM",
              }),
              iconColor: AppColors.orange),
          _listTileWithIconLeading(
              pathImage: AppImages.icStoreSelected,
              title: "introduce".tr,
              iconColor: context.isDarkMode
                  ? AppColors.primaryDarkModeColor
                  : AppColors.primaryLightModeColor),
          _introduceContent(),
          _ratingReviewsCount(),
          _rating(),
          ReviewListCustomerSide(
           reviewDemo: reviewDemoList,
           itemCount:  reviewDemoList.length < 3 ? reviewDemoList.length : 2,
            physics: const NeverScrollableScrollPhysics(),
           padding: EdgeInsets.only(top: 12.h),
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
            TextSpan(text: "4.5", style: AppTextStyle.tex17Bold()),
            TextSpan(text: "/5", style: AppTextStyle.tex15Bold()),
          ])),
          Container(
            margin: EdgeInsets.only(left: 7.w),
            child: SvgPicture.asset(
              StringUtils.getSVGImageAssets(AppImages.icStarSelected),
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
            TextSpan(
                text: "rating_reviews".tr, style: AppTextStyle.tex18Medium()),
            TextSpan(text: " (17)", style: AppTextStyle.tex16Medium()),
          ])),
          TextButton(
              onPressed: () => Get.toNamed(Routes.customerReview),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4)),
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
        "\t bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla",
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
          _listTileWithIconLeading(
              marginTop: 0, pathImage: AppImages.icDistance, title: "1 km"),
          SizedBox(
            width: 200.w,
            child: Text(
              "45 Hà Huy Tập, Đà Nẵng, Việt Nam",
              style: AppTextStyle.tex18Regular(),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              StringUtils.getSVGImageAssets(AppImages.icDirect),
              width: 33.w,
              height: 33.h,
            ),
          ),
        ],
      ),
    );
  }

  Text _shopName() {
    return Text(
      "Tiệm cây khế".toUpperCase(),
      style: AppTextStyle.tex18Regular(),
    );
  }

  Visibility _nontifiClosed() {
    return Visibility(
        visible: false,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Text(
            "closed_store_nontifi".tr,
            style: AppTextStyle.tex18Medium(color: AppColors.red),
            textAlign: TextAlign.justify,
          ),
        ));
  }

  Widget _listTileWithIconLeading(
      {required String pathImage,
      required String title,
      Color? iconColor,
      double marginTop = 12}) {
    return Container(
      margin: EdgeInsets.only(top: marginTop.h),
      child: Row(
        children: [
          SvgPicture.asset(
            StringUtils.getSVGImageAssets(pathImage),
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

  Widget _listTileWithCheckBoxLeading(
      {required bool? value,
      required String title,
      required void Function(bool?)? onChanged,
      required BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.h,
            child: Checkbox(
              value: value,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              shape: const CircleBorder(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged,
              activeColor: context.isDarkMode
                  ? AppColors.primaryDarkModeColor
                  : AppColors.primaryLightModeColor,
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
        height: 230.h,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) => SizedBox(
              width: Get.width,
              height: 230.h,
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 35,
              ),
            ),
        placeholder:
            StringUtils.getPNGImageAssets(AppImages.imageAvaShopDefault),
        image:
            "https://libreshot.com/wp-content/uploads/2016/04/car-repair-shop-2.jpg");
  }
}
