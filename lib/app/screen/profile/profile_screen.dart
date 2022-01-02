import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final _profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(),
      endDrawer:  DrawerApp(),
      body: SingleChildScrollView(
        child: Obx(() => AbsorbPointer(
              absorbing: !_profileController.isEdit,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    _avatar(context),
                    _infoTextField(lable: "my_name".tr, hintText: "enter_name".tr, imagePath: AppImages.icUser),
                    _infoTextField(lable: "phone_number".tr, hintText: "enter_your_phone_number".tr, imagePath: AppImages.icCall),
                  ],
                ),
              ),
            )),
      ),
    ));
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

  _avatar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          children: [
            CircleAvatar(
              radius: 80.h,
              backgroundColor: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: AppImages.imageDefautAvatar.getPNGImageAssets,
                  image: "https://thuthuatnhanh.com/wp-content/uploads/2019/06/anh-anime-nam.jpg",
                  imageErrorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error,
                    color: AppColors.white,
                  ),
                  fit: BoxFit.cover,
                  width: 150.h,
                  height: 150.h,
                ),
              ),
            ),
            Positioned(
              bottom: 10.h,
              right: 10.w,
              child: CircleAvatar(
                radius: 18.h,
                backgroundColor: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
                child: Icon(
                  Icons.camera_enhance,
                  color: AppColors.white,
                  size: 23.h,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(55.h),
      child: Obx(() => appBarPopular(title: _profileController.isEdit ? Text("edit_my_profile".tr) : Text("my_profile".tr), centerTitle: true, actions: [
            IconButton(
                onPressed: () {
                  _profileController.isEdit = !_profileController.isEdit;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                icon: Icon(
                  _profileController.isEdit ? Icons.done : Icons.edit,
                  size: 25.h,
                ))
          ])),
    );
  }
}
