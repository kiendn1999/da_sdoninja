import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_radius.dart';
import 'package:da_sdoninja/app/constant/app_shadows.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/authen_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/form_login_phone_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginWithPhoneNumberScreen extends StatefulWidget {
  const LoginWithPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  _LoginWithPhoneNumberScreenState createState() => _LoginWithPhoneNumberScreenState();
}

class _LoginWithPhoneNumberScreenState extends State<LoginWithPhoneNumberScreen> {
  final _authenController = Get.find<AuthController>();
  final _loginWithPhoneController = Get.find<FormLoginWithPhoneController>();

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
              children: [_image(context), _textFileldEnterNumber(), _buttonResendOTP(), _buttonSend()],
            ),
          ),
        ),
      ),
    );
  }

  Container _buttonResendOTP() {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: TextButton(
          onPressed: () async => _loginWithPhoneController.phoneNumberTextFieldController.text = (await _loginWithPhoneController.autoFill.hint)!,
          child: Text(
            "get_current_number".tr,
            style: AppTextStyle.tex22Regular(color: AppColors.green),
          )),
    );
  }

  Widget _buttonSend() {
    return buttonWithRadius90(
        onPressed: () async => _loginWithPhoneController.checkInvalidPhoneNumberToVerify
            ? await _authenController.verifyPhoneNumber(phoneNumber: _loginWithPhoneController.phoneNumberTextFieldController.text)
            : null,
        child: Text(
          "send".tr,
          style: AppTextStyle.tex25Bold(),
        ),
        horizontalPadding: 45.w,
        verticalPadding: 14.h);
  }

  Widget _textFileldEnterNumber() {
    return Form(
      key: _loginWithPhoneController.loginFormKey,
      child: textFormFieldApp(
        hintText: "enter_your_phone_number".tr,
        radius: AppRadius.radius90,
        textAlign: TextAlign.center,
        controller: _loginWithPhoneController.phoneNumberTextFieldController,
        errorStyle: AppTextStyle.tex18Regular(),
        keyboardType: TextInputType.phone,
        style: AppTextStyle.tex24Regular(),
        validator: (value) => _loginWithPhoneController.validatePhoneNumber(value!),
        marginTop: 18.h,
        contentPadding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 19.h),
      ),
    );
  }

  Widget _image(BuildContext context) => AppShadow.lightShadow(
          child: Image.asset(
        AppImages.imageLoginWithNumber.getPNGImageAssets,
        width: 324.w,
        height: 318.h,
        color: context.isDarkMode ? AppColors.primaryDarkModeColor : null,
      ));
}
