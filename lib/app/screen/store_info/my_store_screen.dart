import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/my_store_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MyStoreScreen extends StatelessWidget {
  //const MyStoreScreen({Key? key}) : super(key: key);
  final bool isAddStoreScreen;
  MyStoreScreen({this.isAddStoreScreen = false});
  final List<String> _storeTypeList = ["motorcycle".tr, "car".tr, "computer".tr, "mobile_phone".tr, "electronic_device".tr, "refrigeration_device".tr, "electrical_equipment".tr];
  final _myStoreContorller = Get.find<MyStoreController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AbsorbPointer(
        absorbing: false,
        child: Column(
          children: [
            _shopImageAva(context),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _infoTextField(lable: "store_name".tr, hintText: "enter_store_name".tr, imagePath: AppImages.icStoreSelected),
                  _infoTextField(lable: "address".tr, hintText: "enter_address".tr, imagePath: AppImages.icMapSelected),
                  _infoTextField(lable: "phone_number".tr, hintText: "enter_your_phone_number".tr, imagePath: AppImages.icCall),
                  _storeTypeCheckBoxGridView(),
                  _introduce(),
                  _termAndPolicyCheckBox(),
                  _sendButton()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Visibility _sendButton() {
    return Visibility(
      visible: isAddStoreScreen,
      child: buttonWithRadius10(
          onPressed: () {},
          child: Text(
            "send".tr,
            style: AppTextStyle.tex18Medium(),
          ),
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          margin: EdgeInsets.symmetric(vertical: 15.h)),
    );
  }

  Visibility _termAndPolicyCheckBox() {
    return Visibility(
      visible: isAddStoreScreen,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: false,
              onChanged: (value) {},
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 7.w),
                child: Text.rich(
                  TextSpan(style: AppTextStyle.tex16Regular(), children: [
                    TextSpan(text: "i_agree_to".tr),
                    WidgetSpan(
                        child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "the_terms_and_policies".tr,
                        style: AppTextStyle.tex16Regular(color: AppColors.blue2),
                      ),
                    )),
                    TextSpan(text: "of_sdoninja".tr),
                  ]),
                  textAlign: TextAlign.justify,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _introduce() {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_introduceTitle(), _introduceTextField(), _checkBoxIntroduce()],
      ),
    );
  }

  Container _introduceTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          textFormFieldApp(
            hintText: "enter_referrals".tr,
            style: AppTextStyle.tex18Regular(),
            maxLines: 20,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          ),
          GestureDetector(
            onTap: () {
              print("adasdas");
            },
            child: Padding(
              padding: EdgeInsets.only(top: 5.h, right: 5.w),
              child: Icon(
                Icons.clear,
                size: 25.h,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _checkBoxIntroduce() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                Text(
                  "on_site_repair".tr,
                  style: AppTextStyle.tex16Regular(),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                Text(
                  "delivery".tr,
                  style: AppTextStyle.tex16Regular(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Text _introduceTitle() {
    return Text(
      "introduce".tr,
      style: AppTextStyle.tex18Regular(),
    );
  }

  Container _storeTypeCheckBoxGridView() {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "repair_store_type".tr,
            style: AppTextStyle.tex18Regular(),
          ),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 4,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
                _storeTypeList.length,
                (index) => InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Checkbox(value: false, onChanged: (value) {}),
                          Text(
                            _storeTypeList[index],
                            style: AppTextStyle.tex16Regular(),
                          ),
                        ],
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  _infoTextField({required String lable, required String hintText, required String imagePath}) {
    return Builder(
        builder: (context) => Container(
              margin: EdgeInsets.only(top: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lable,
                    style: AppTextStyle.tex18Regular(),
                  ),
                  textFormFieldApp(
                      hintText: hintText,
                      style: AppTextStyle.tex18Regular(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                      iconHeight: 25.h,
                      marginTop: 5.h,
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: 15.w),
                        child: SvgPicture.asset(
                          imagePath.getSVGImageAssets,
                          width: 25.w,
                          height: 25.h,
                          color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
                        ),
                      ))
                ],
              ),
            ));
  }

  _shopImageAva(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        FadeInImage.assetNetwork(
            width: Get.width,
            height: 200.h,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) => SizedBox(
                  width: Get.width,
                  height: 200.h,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 35,
                  ),
                ),
            placeholder: AppImages.imageAvaShopDefault.getPNGImageAssets,
            image: "https://libreshot.com/wp-content/uploads/2016/04/car-repair-shop-2.jpg"),
        Card(
          shape: const CircleBorder(),
          margin: EdgeInsets.only(top: 5.h, right: 5.w),
          color: (context.isDarkMode ? AppColors.black : AppColors.white).withOpacity(0.5),
          child: IconButton(
            iconSize: 25.h,
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minHeight: 35.h, minWidth: 35.w),
            icon: Icon(
              Icons.camera_enhance,
              color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
            ),
          ),
        )
      ],
    );
  }
}
