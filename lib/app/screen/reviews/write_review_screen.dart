import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/write_review_controller.dart';
import 'package:da_sdoninja/app/data/model/demo/order_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WriteReviewScreen extends StatelessWidget {
  final _writeReivewController = Get.find<WriteReviewController>();
  final TextEditingController _writeReviewTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(),
      extendBody: true,
      endDrawer: const DrawerApp(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h),
          child: Column(
            children: [
              _listTileWithIconLeading(pathImage: AppImages.icDevice, title: "device_name".tr + ": ${orderDemoList[1].deviceName}"),
              _listTileWithIconLeading(pathImage: AppImages.icBrokenCause, title: "broken_cause".tr + ": ${orderDemoList[1].brokenCause}"),
              _listTileWithIconLeading(pathImage: AppImages.icRepairCost, title: "repair_cost".tr + ": ${orderDemoList[1].repairCost} VND"),
              _rating(),
              _writeReviewTextField()
            ],
          ),
        ),
      ),
      bottomNavigationBar: _button(),
    ));
  }

  _button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        true
            ? buttonWithRadius10(
                onPressed: () {},
                child: Text(
                  "save_review".tr,
                  style: AppTextStyle.tex18Medium(),
                ),
                color: AppColors.green,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h))
            : buttonWithRadius10(
                onPressed: () {},
                child: Text(
                  "submit_a_review".tr,
                  style: AppTextStyle.tex18Medium(),
                ),
                color: AppColors.blue2,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h)),
      ],
    );
  }
  

  Container _writeReviewTextField() {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          textFormFieldApp(
            hintText: "enter_a_review".tr,
            style: AppTextStyle.tex18Regular(),
            controller: _writeReviewTextFieldController,
            minLines: 15,
            contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 25.w, 10.h),
          ),
          GestureDetector(
            onTap: () {
              print("adasdas");
            },
            child: InkWell(
              onTap: () {
                _writeReviewTextFieldController.clear();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 5.h, right: 5.w),
                child: Icon(
                  Icons.clear,
                  size: 25.h,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column _rating() {
    return Column(
      children: [
        Obx(() => Container(
              margin: EdgeInsets.only(top: 10.h),
              child: Text(
                _writeReivewController.satisfactionLevel,
                style: AppTextStyle.tex18Regular(),
              ),
            )),
        Container(
          margin: EdgeInsets.only(top: 10.h),
          child: RatingBar.builder(
            initialRating: 5,
            minRating: 1,
            direction: Axis.horizontal,
            itemSize: 40.h,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 10.w),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _writeReivewController.setSatisfactionLevel(rating);
            },
          ),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return appBarPopular(
        title: Text(true ? "edit_review".tr : "write_a_review".tr),
        centerTitle: true,
        actions: true
            ? [
                IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AppImages.icTrash.getSVGImageAssets,
                      color: AppColors.white,
                      width: 25.w,
                      height: 25.h,
                    ))
              ]
            : null);
  }

  Widget _listTileWithIconLeading({
    required String pathImage,
    required String title,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            pathImage.getSVGImageAssets,
            width: 22.w,
            height: 22.h,
            color: iconColor,
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 5.h),
                child: Text(
                  title,
                  textAlign: TextAlign.justify,
                  style: AppTextStyle.tex17Regular(),
                )),
          )
        ],
      ),
    );
  }
}
