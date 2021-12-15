import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_radius.dart';
import 'package:da_sdoninja/app/constant/app_shadows.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/home_custom_controller.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/data/model/demo/shop_model.dart';
import 'package:da_sdoninja/app/utils/string_utils.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/dropdown_button.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeCustomerScreen extends StatelessWidget {
  final _homeCustomerController = Get.find<HomeCustomerController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          _filterTool(
            itemList: ["all_devices".tr, "motorcycle".tr, "car".tr, "computer".tr, "mobile_phone".tr, "electronic_device".tr, "refrigeration_device".tr, "electrical_equipment".tr],
            lable: "question_tus".tr,
            marginTop: 12.h,
            widthDropDownButton: 190.w,
            widthLable: 120.w,
            value: _homeCustomerController.dropdownDeviceValue,
            onChanged: (newValue) {
              _homeCustomerController.dropdownDeviceValue = newValue!;
            },
          ),
          _searchStoreTextField(context),
          _filterTool(
            itemList: [
              "near_you".tr,
              "rating".tr,
            ],
            lable: "recommended_shops".tr,
            widthDropDownButton: 147.w,
            marginTop: 17.h,
            value: _homeCustomerController.dropdownFilterValue,
            onChanged: (newValue) {
              _homeCustomerController.dropdownFilterValue = newValue!;
            },
          ),
          _shopsListView(),
        ],
      ),
    );
  }

  Expanded _shopsListView() => Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 17.h),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 7.h,
            ),
            itemCount: shopDemoList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _shopsItem(index);
            },
          ),
        ),
      );

  _shopsItem(int index) => AppShadow.lightShadow(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius15)),
          child: InkWell(
            onTap: () => Get.toNamed(Routes.storeDetail),
            borderRadius: BorderRadius.circular(AppRadius.radius15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.radius15),
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Row(
                  children: [_shopsAvatar(index), Expanded(child: _shopInfor(index))],
                ),
              ),
            ),
          ),
        ),
      );

  Container _shopInfor(int index) => Container(
        margin: EdgeInsets.only(left: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_shopName(index), _shopRating(index), _shopDistance(index), _buttonRow()],
        ),
      );

  Container _buttonRow() => Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buttonWithRadius10(
                onPressed: () {},
                color: AppColors.orange,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Text(
                  "help_me".tr,
                  style: AppTextStyle.tex18Bold(),
                )),
            buttonWithRadius10(
                onPressed: () {},
                color: AppColors.green,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Text(
                  "direct".tr,
                  style: AppTextStyle.tex18Bold(),
                ))
          ],
        ),
      );

  Container _shopDistance(int index) => Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          children: [
            SvgPicture.asset(
              StringUtils.getSVGImageAssets(AppImages.icDistance),
              width: 22.w,
              height: 22.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 8.w),
              child: Text(
                "${shopDemoList[index].distance} km",
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
              StringUtils.getSVGImageAssets(AppImages.icStarSelected),
              width: 22.w,
              height: 22.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 8.w),
              child: Text(
                "${shopDemoList[index].rate} (${shopDemoList[index].quantity})",
                style: AppTextStyle.tex18Regular(),
              ),
            )
          ],
        ),
      );

  Text _shopName(int index) => Text(
        shopDemoList[index].name,
        style: AppTextStyle.tex18Regular(),
      );

  FadeInImage _shopsAvatar(int index) => FadeInImage.assetNetwork(
      width: 120.w,
      height: 145.h,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, error, stackTrace) => SizedBox(
            width: 120.w,
            height: 145.h,
            child: const Icon(
              Icons.image_not_supported_outlined,
              size: 35,
            ),
          ),
      placeholder: StringUtils.getPNGImageAssets(AppImages.imageAvaShopDefault),
      image: shopDemoList[index].image);

  Widget _searchStoreTextField(BuildContext context) => textFormFieldApp(
        marginTop: 17.h,
        contentPadding: EdgeInsets.only(top: 13.h, bottom: 13.h, left: 26.w),
        hintText: "enter_name_to_search".tr,
        style: AppTextStyle.tex17Regular(),
        iconHeight: 23.h,
        textAlign: TextAlign.center,
        radius: AppRadius.radius90,
        suffixIcon: Container(
          margin: EdgeInsets.only(right: 26.w, left: 15.w),
          child: SvgPicture.asset(
            StringUtils.getSVGImageAssets(AppImages.icSearch),
            color: context.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      );

  Widget _filterTool(
          {double? widthLable,
          required String lable,
          double marginTop = 0,
          required List<String> itemList,
          required double widthDropDownButton,
          String? value,
          void Function(String?)? onChanged}) =>
      Container(
        margin: EdgeInsets.only(top: marginTop),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: widthLable,
              child: Text(
                lable,
                style: AppTextStyle.tex18Regular(),
              ),
            ),
            dropDownButton(
              width: widthDropDownButton,
              itemList: itemList,
              contentPaddingHorizontal: 20.w,
              menuMaxHeight: 250.h,
              contentPaddingVertical: 7.h,
              value: value,
              onChanged: onChanged,
            )
          ],
        ),
      );
}
