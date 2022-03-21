import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/manage_review_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../widgets/review_list.dart';

class ManageReviewScreen extends StatefulWidget {
  String? storeID;
  ManageReviewScreen({
    Key? key,
    required this.storeID,
  }) : super(key: key);

  @override
  State<ManageReviewScreen> createState() => _ManageReviewScreenState();
}

class _ManageReviewScreenState extends State<ManageReviewScreen> {
  final _manageReviewController = Get.find<ManageReviewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _manageReviewController.currentIndex = 0;
    _manageReviewController.storeID = widget.storeID!;
    _manageReviewController.getAllReview();
    _manageReviewController.getAllStatis();
  }

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
                  Obx(() => Text(
                        _manageReviewController.statis.value.rating == 0 ? "not_yet".tr : "${_manageReviewController.statis.value.rating}",
                        style: AppTextStyle.tex20Regular(),
                      )),
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
              controller: _manageReviewController.pageController,
              onPageChanged: (index) {
                _manageReviewController.currentIndex = index;
              },
              itemBuilder: (context, index) {
                return Obx(() => _manageReviewController.listOfListReview[index].isEmpty
                    ? Center(
                        child: Image.asset(
                          AppImages.imageLoad.getGIFImageAssets,
                          width: Get.width,
                          height: 400.h,
                        ),
                      )
                    : ReviewList(
                        itemCount: _manageReviewController.listOfListReview[index].length,
                        reviews: _manageReviewController.listOfListReview[index],
                        padding: EdgeInsets.only(top: 12.h, left: 10.w, right: 10.w),
                        isManageReviewList: true,
                        manageReviewController: _manageReviewController,
                      ));
              }),
        )
      ],
    );
  }
}
