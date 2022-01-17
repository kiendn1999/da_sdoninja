import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/manage_review_controller.dart';
import 'package:da_sdoninja/app/data/model/demo/review_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/chip.dart';
import 'package:da_sdoninja/app/widgets/review_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ManageReviewScreen extends StatelessWidget {
  final _manageReviewController = Get.find<ManageReivewController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "rating_reviews".tr,
                style: AppTextStyle.tex20Regular(),
              ),
              Row(
                children: [
                  Text(
                    "4.5",
                    style: AppTextStyle.tex20Regular(),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7.w),
                    child: SvgPicture.asset(
                      AppImages.icStarSelected.getSVGImageAssets,
                      width: 20.w,
                      height: 20.h,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        ReviewChipChoice(_manageReviewController),
        Expanded(
          child: PageView.builder(
              itemCount: 6,
              reverse: true,
              controller: _manageReviewController.pageController,
              onPageChanged: (index) {
                _manageReviewController.currentIndex = index;
              },
              itemBuilder: (context, index) {
                return ReviewList(
                  itemCount: reviewDemoList.length,
                  reviewDemo: reviewDemoList,
                  isManageReviewList: true,
                  padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                );
              }),
        )
      ],
    );
  }
}
