import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/write_review_controller.dart';
import 'package:da_sdoninja/app/data/model/order_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constant/theme/app_radius.dart';

class WriteReviewScreen extends StatefulWidget {
  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _writeReviewController = Get.find<WriteReviewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _writeReviewController.getDataReview(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(),
      extendBody: true,
      endDrawer: DrawerApp(),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h),
            child: Column(
              children: [
                _listTileWithIconLeading(pathImage: AppImages.icDevice, title: "device_name".tr + ": ${Get.arguments.deviceName}"),
                _listTileWithIconLeading(pathImage: AppImages.icBrokenCause, title: "broken_cause".tr + ": ${Get.arguments.brokenCause}"),
                _listTileWithIconLeading(pathImage: AppImages.icRepairCost, title: "repair_cost".tr + ": ${Get.arguments.repairCost} VND"),
                _rating(),
                _writeReviewTextField()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _button(),
    ));
  }

  _button() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _writeReviewController.isCommented.value
                ? buttonWithRadius10(
                    onPressed: () {
                      if (_writeReviewController.formKey.currentState!.validate()) _writeReviewController.updateReview(Get.arguments);
                      return;
                    },
                    child: Text(
                      "save_review".tr,
                      style: AppTextStyle.tex18Medium(),
                    ),
                    color: AppColors.green,
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h))
                : buttonWithRadius10(
                    onPressed: () {
                      if (_writeReviewController.formKey.currentState!.validate()) _writeReviewController.submitReview(Get.arguments);
                      return;
                    },
                    child: Text(
                      "submit_a_review".tr,
                      style: AppTextStyle.tex18Medium(),
                    ),
                    color: AppColors.blue2,
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h)),
          ],
        ));
  }

  Container _writeReviewTextField() {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Form(
            key: _writeReviewController.formKey,
            child: textFormFieldApp(
              hintText: "enter_a_review".tr,
              style: AppTextStyle.tex18Regular(),
              controller: _writeReviewController.reviewTextFieldController,
              maxLines: 15,
              validator: (value) => _writeReviewController.validateReview(value!),
              contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 25.w, 10.h),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("adasdas");
            },
            child: InkWell(
              onTap: () {
                _writeReviewController.reviewTextFieldController.clear();
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

  _rating() {
    return Obx(() => Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.h),
              child: Text(
                _writeReviewController.satisfactionLevel,
                style: AppTextStyle.tex18Regular(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h),
              child: RatingBar.builder(
                initialRating: _writeReviewController.review.value.rating!.toDouble(),
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
                  _writeReviewController.setSatisfactionLevel(rating.toInt());
                },
              ),
            ),
          ],
        ));
  }

  _appBar() {
    return PreferredSize(
        child: Obx((() => appBarPopular(
            title: Text(_writeReviewController.isCommented.value ? "edit_review".tr : "write_a_review".tr),
            centerTitle: true,
            actions: _writeReviewController.isCommented.value
                ? [
                    IconButton(
                        onPressed: () => _showDialogConfirm(Get.arguments),
                        icon: SvgPicture.asset(
                          AppImages.icTrash.getSVGImageAssets,
                          color: AppColors.white,
                          width: 25.w,
                          height: 25.h,
                        ))
                  ]
                : null))),
        preferredSize: Size(Get.width, 50.h));
  }

  Future<Object?> _showDialogConfirm(OrderModel order) {
    return showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.slideFromTopFade,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "do_you_want_to_delete_this_review".tr,
            style: AppTextStyle.tex18Regular(),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  await _writeReviewController.deleteReview(order);
                },
                child: Text(
                  "yes".tr,
                  style: AppTextStyle.tex16Medium(),
                )),
            TextButton(onPressed: () => Get.back(), child: Text("no".tr, style: AppTextStyle.tex16Medium())),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius10)),
          titlePadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
          elevation: 7,
        );
      },
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _writeReviewController.reviewTextFieldController.dispose();
  }
}
