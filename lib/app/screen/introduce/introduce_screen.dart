import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/utils/string_utils.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IntroduceScreeen extends StatelessWidget {
  const IntroduceScreeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _introduceImage(),
              _introduceCaption(),
              _button(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button() => buttonWithRadius90(
      onPressed: () => Get.toNamed(Routes.login),
      child: Text(
        "let_go".tr,
        style: AppTextStyle.tex18Bold(),
      ),
      marginTop: 30.h,
      horizontalPadding: 49.w,
      verticalPadding: 14.h);

  Container _introduceCaption() => Container(
        margin: EdgeInsets.only(top: 30.h),
        child: Text(
          "caption_introduce".tr,
          style: AppTextStyle.tex18Regular(),
          textAlign: TextAlign.center,
        ),
      );

  Image _introduceImage() => Image.asset(
        StringUtils.getPNGImageAssets(AppImages.imageIntroduce),
        width: 393.w,
        height: 289.h,
      );
}
