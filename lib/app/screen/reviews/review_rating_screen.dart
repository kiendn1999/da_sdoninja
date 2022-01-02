import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/customer_review_controller.dart';
import 'package:da_sdoninja/app/data/model/demo/review_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/chip.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/review_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomerReviewScreen extends StatelessWidget {
  final _reviewController = Get.find<CustomerReviewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(),
      endDrawer:  DrawerApp(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReviewChipChoice(_reviewController),
          Expanded(
            child: PageView.builder(
                itemCount: 6,
                reverse: true,
                controller: _reviewController.pageController,
                onPageChanged: (index) {
                  _reviewController.currentIndex = index;
                },
                itemBuilder: (context, index) {
                  return ReviewList(
                    itemCount: reviewDemoList.length,
                    reviewDemo: reviewDemoList,
                    padding: EdgeInsets.only(top: 12.h, left: 10.w, right: 10.w),
                  );
                }),
          )
        ],
      ),
    ));
  }

  AppBar _appBar() {
    return appBarPopular(title: Text("rating_reviews".tr), centerTitle: true, actions: [
      Container(
        margin: EdgeInsets.only(right: 15.w),
        child: Row(
          children: [
            Text("4.5"),
            Container(
              margin: EdgeInsets.only(left: 5.h),
              child: SvgPicture.asset(
               AppImages.icStarSelected.getSVGImageAssets,
                width: 20.w,
                height: 20.h,
              ),
            )
          ],
        ),
      )
    ]);
  }
}
