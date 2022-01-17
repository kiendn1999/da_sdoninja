import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_radius.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/authen_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final AuthController _authenController;
  late final ProfileController  _profileController;

  final TextEditingController _otpTextFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    switch (Get.arguments[1]) {
      case 1:
        _authenController = Get.find<AuthController>();
        break;
      case 2:
        _profileController = Get.find<ProfileController>();
        break;
      default:
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarTransparent(
            backIconButtonColor: context.isDarkMode ? AppColors.white : AppColors.black1, primaryBackButtonColor: context.isDarkMode ? Colors.black54 : AppColors.white),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 70.h, right: 35.w, left: 35.h),
            height: Get.height - 110.h,
            child: Column(
              children: [
                _image(context),
                _otpWarningText(),
                _textFiledEnterOTP(),
                _buttonResendOTP(),
                _buttonConfirm(),
                _buttonDontReceiveOTP(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buttonDontReceiveOTP() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: TextButton(
          onPressed: () => Get.offAllNamed(Routes.login),
          child: Text("Did_not_receive_otp".tr, style: AppTextStyle.tex22Regular(color: AppColors.red)),
        ),
      ),
    );
  }

  Widget _buttonConfirm() {
    return buttonWithRadius90(
        onPressed: () {
          switch (Get.arguments[1]) {
            case 1:
              _authenController.signInWithPhoneNumber(otpCode: _otpTextFieldController.text);
              break;
            case 2:
              _profileController.updatePhoneNumber(otpCode: _otpTextFieldController.text, phoneNumber: Get.arguments[0]);
              break;
            default:
          }
        },
        child: Text(
          "confirm".tr,
          style: AppTextStyle.tex25Bold(),
        ),
        horizontalPadding: 45.w,
        verticalPadding: 14.h);
  }

  TextButton _buttonResendOTP() {
    return TextButton(
        onPressed: () {},
        child: Text(
          "resend_code".tr,
          style: AppTextStyle.tex22Regular(color: AppColors.green),
        ));
  }

  Widget _textFiledEnterOTP() {
    return textFormFieldApp(
      hintText: "enter_otp".tr,
      style: AppTextStyle.tex24Regular(),
      controller: _otpTextFieldController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      radius: AppRadius.radius90,
      marginTop: 18.h,
      contentPadding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 19.h),
    );
  }

  Container _otpWarningText() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Text(
        "otp_warning".trParams({'number': Get.arguments[0]}),
        style: AppTextStyle.tex22Medium(),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Image _image(BuildContext context) {
    return Image.asset(
      AppImages.imageOtpVerification.getPNGImageAssets,
      width: 322.w,
      height: 250.h,
      color: context.isDarkMode ? AppColors.primaryDarkModeColor : null,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _otpTextFieldController.dispose();
    super.dispose();
  }
}
