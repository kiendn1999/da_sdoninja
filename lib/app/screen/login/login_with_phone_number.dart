import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_radius.dart';
import 'package:da_sdoninja/app/constant/app_shadows.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginWithPhoneNumber extends StatelessWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBarTransparent(
            backIconButtonColor: context.isDarkMode ? AppColors.white : AppColors.black1, primaryBackButtonColor: context.isDarkMode ? Colors.black54 : AppColors.white),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 60.h, right: 35.w, left: 35.h),
            child: Column(
              children: [_image(context), _textFileldEnterNumber(), _buttonSend()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonSend() {
    return buttonWithRadius90(
        onPressed: () => Get.toNamed(Routes.otpVerification),
        child: Text(
          "send".tr,
          style: AppTextStyle.tex25Bold(),
        ),
        marginTop: 30.h,
        horizontalPadding: 45.w,
        verticalPadding: 14.h);
  }

  Widget _textFileldEnterNumber() {
    return textFormFieldApp(
      hintText: "enter_your_phone_number".tr,
      
      radius: AppRadius.radius90,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: AppTextStyle.tex24Regular(),
      marginTop: 18.h,
      contentPadding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 19.h),
    );
  }

  Widget _image(BuildContext context) {
    return AppShadow.lightShadow(
        child: Image.asset(
     AppImages.imageLoginWithNumber.getPNGImageAssets,
      width: 324.w,
      height: 318.h,
      color: context.isDarkMode ? AppColors.primaryDarkModeColor : null,
    ));
  }
}
