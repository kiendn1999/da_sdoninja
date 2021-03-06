import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_shadows.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/authen_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/circular_progess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final _authenController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(AppImages.imageBackgroundLogin.getPNGImageAssets), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _logoAppLogin(),
              _instructionText(),
              _loginButton(imageAsset: AppImages.icPhoneLogin, onPressed: () => Get.toNamed(Routes.loginWithPhoneNumber), textButton: "phone_number".tr),
              _loginButton(imageAsset: AppImages.icGoogleLogin, onPressed: () async => await _authenController.signInWithGoogle(), textButton: "Google"),
              _loginButton(imageAsset: AppImages.icFbLogin, onPressed: () async => await _authenController.signInWithFacebook(), textButton: "Facebook".tr),
            ],
          )),
        ),
      ),
    );
  }

  _loginButton({required String imageAsset, required String textButton, required void Function() onPressed}) => Container(
        margin: EdgeInsets.only(top: 41.h),
        child: AppShadow.boldShadow(
            child: buttonWithRadius10(
                onPressed: onPressed,
                fixedSize: Size(301.w, 75.h),
                color: AppColors.primaryLightModeColor,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SvgPicture.asset(
                        imageAsset.getSVGImageAssets,
                        width: 42.w,
                        height: 42.h,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          textButton,
                          style: AppTextStyle.tex24Bold(),
                        ),
                      ),
                    )
                  ],
                ))),
      );

  Widget _instructionText() => Container(
        margin: EdgeInsets.only(top: 41.h),
        child: AppShadow.boldShadow(
            child: Text(
          "login_with".tr,
          style: AppTextStyle.tex24Bold(
            color: AppColors.primaryDarkModeColor,
          ),
        )),
      );

  RichText _logoAppLogin() => RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: 47.sp,
              fontWeight: FontWeight.bold,
              shadows: const [BoxShadow(color: AppColors.black1, offset: Offset(10, 10), blurRadius: 3)],
              color: AppColors.primaryDarkModeColor,
              fontStyle: FontStyle.italic),
          children: [
            const TextSpan(text: "SD"),
            WidgetSpan(
              child: AppShadow.boldShadow(
                  child: CircularProgressApp(
                width: 60.h,
                height: 60.h,
                color: AppColors.primaryDarkModeColor,
              )),
            ),
            const TextSpan(text: "NINJA"),
          ],
        ),
      );
}
