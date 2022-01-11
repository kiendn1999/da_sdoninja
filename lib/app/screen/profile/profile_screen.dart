import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/form_fileld_profile_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileController = Get.find<ProfileController>();
  final _formFiledProfileController = Get.find<FormFieldProfileController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(),
      endDrawer: DrawerApp(),
      body: SingleChildScrollView(
        child: Obx(() => AbsorbPointer(
              absorbing: !_formFiledProfileController.isEdit,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    _avatar(context),
                    Form(
                        key: _formFiledProfileController.updateProfileFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoTextField(
                              lable: "my_name".tr,
                              hintText: "enter_name".tr,
                              imagePath: AppImages.icUser,
                              controller: _formFiledProfileController.userNameTextFieldController,
                              validator: (value) => _formFiledProfileController.validateUserName(value!),
                            ),
                            _infoTextField(
                              lable: "phone_number".tr,
                              hintText: "enter_your_phone_number".tr,
                              imagePath: AppImages.icCall,
                              keyboardType: TextInputType.phone,
                              controller: _formFiledProfileController.phomeNumberTextFieldController,
                              validator: (value) => _formFiledProfileController.validatePhoneNumber(value!),
                            ),
                            _autoEnterCurrentPhoneNumberButton()
                          ],
                        ))
                  ],
                ),
              ),
            )),
      ),
    ));
  }

  TextButton _autoEnterCurrentPhoneNumberButton() {
    return TextButton(
        onPressed: () async => _formFiledProfileController.phomeNumberTextFieldController.text = (await _formFiledProfileController.autoFill.hint)!,
        child: Text(
          "get_current_number".tr,
          style: AppTextStyle.tex16Regular(color: AppColors.green),
        ));
  }

  _infoTextField(
      {required String lable,
      required String hintText,
      required String imagePath,
      TextEditingController? controller,
      TextInputType? keyboardType,
      String? Function(String?)? validator}) {
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
                      controller: controller,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                      iconHeight: 25.h,
                      marginTop: 5.h,
                      keyboardType: keyboardType,
                      validator: validator,
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
                  image: _profileController.avaURL.toString(),
                  imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                    AppImages.imageDefautAvatar.getPNGImageAssets,
                    fit: BoxFit.cover,
                    width: 150.h,
                    height: 150.h,
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
      child: Obx(() => appBarPopular(title: _formFiledProfileController.isEdit ? Text("edit_my_profile".tr) : Text("my_profile".tr), centerTitle: true, actions: [
            IconButton(
                onPressed: () async => _formFiledProfileController.checkInvalidForm
                    ? await _profileController.updateProfile(
                        _formFiledProfileController.userNameTextFieldController.text, _formFiledProfileController.phomeNumberTextFieldController.text)
                    : null,
                icon: Icon(
                  _formFiledProfileController.isEdit ? Icons.done : Icons.edit,
                  size: 25.h,
                ))
          ])),
    );
  }
}
