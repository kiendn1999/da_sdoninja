import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_radius.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/manage_review_controller.dart';
import 'package:da_sdoninja/app/data/model/review_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

import 'button_widget.dart';

class ReviewList extends StatelessWidget {
  late final List<ReviewModel> reviews;
  late final int itemCount;
  late final bool isManageReviewList;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final ManageReviewController? manageReviewController;

  ReviewList({required this.reviews, required this.itemCount, this.manageReviewController, this.physics, this.padding, this.isManageReviewList = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: padding,
      separatorBuilder: (context, index) => SizedBox(
        height: 12.h,
      ),
      itemCount: itemCount,
      physics: physics,
      itemBuilder: (context, index) {
        return Obx(() => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _avatarImage(index),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 10.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [_customerName(index), _ratingAndDate(index, context), _reviewContent(index), _devieAndPrice(index), _respondFromStore(index, context)],
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }

  Widget _respondFromStore(int index, BuildContext context) {
    return Visibility(
      visible: reviews[index].respond != null ? true : false,
      child: Container(
        margin: EdgeInsets.only(top: 5.h, left: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "store_reply".tr,
                  style: AppTextStyle.tex15Regular(color: AppColors.green),
                ),
                Visibility(
                  visible: isManageReviewList,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          manageReviewController!.respondTextFieldController.text = reviews[index].respond!;
                          _showReplyDialog(context,
                              buttonTitle: "save".tr,
                              dialogTitle: "edit_reply_to".trParams({"name": reviews[index].customer!.value.userName!}),
                              onPressed: () => manageReviewController!.updateRespond(reviews[index]));
                        },
                        child: SvgPicture.asset(
                          AppImages.icPen.getSVGImageAssets,
                          width: 22.w,
                          height: 22.h,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40.w),
                        child: InkWell(
                          onTap: () => _showDialogConfirm(index),
                          child: SvgPicture.asset(
                            AppImages.icTrash.getSVGImageAssets,
                            width: 22.w,
                            height: 22.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5.h),
              child: Text(
                "${reviews[index].respond}",
                style: AppTextStyle.tex14Regular(),
                textAlign: TextAlign.justify,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _devieAndPrice(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Text(
        "device_broken_price".trParams({
          "device": reviews[index].deviceName!,
          "brokenCause": reviews[index].brokenCause!,
          "price": reviews[index].price.toString(),
        }),
        textAlign: TextAlign.justify,
        style: AppTextStyle.tex14Regular(color: AppColors.blue2),
      ),
    );
  }

  Container _reviewContent(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Text(
        reviews[index].content!,
        textAlign: TextAlign.justify,
        style: AppTextStyle.tex14Regular(),
      ),
    );
  }

  Container _ratingAndDate(int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(TextSpan(style: AppTextStyle.tex14Regular(), children: [
            TextSpan(text: reviews[index].rating.toString()),
            WidgetSpan(
                child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 10.w),
              child: SvgPicture.asset(
                AppImages.icStarSelected.getSVGImageAssets,
                height: 17.h,
                width: 17.w,
              ),
            )),
            TextSpan(text: reviews[index].reviewDate),
          ])),
          Visibility(
            visible: isManageReviewList && reviews[index].respond == null,
            child: TextButton(
              onPressed: () => _showReplyDialog(context,
                  buttonTitle: "send".tr,
                  dialogTitle: "reply_to".trParams({"name": reviews[index].customer!.value.userName!}),
                  onPressed: () => manageReviewController!.submitRespond(reviews[index])),
              child: Text(
                "reply".tr,
                style: AppTextStyle.tex14Bold(color: AppColors.green),
              ),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 15.w),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
            ),
          )
        ],
      ),
    );
  }

  Future<Object?> _showReplyDialog(BuildContext context, {required String buttonTitle, required String dialogTitle, required void Function() onPressed}) {
    return showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.slideFromTopFade,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Form(
          key: manageReviewController!.formKey,
          child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  Text(
                    dialogTitle,
                    style: AppTextStyle.tex20Regular(),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              titlePadding: EdgeInsets.only(left: 20.w),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
              elevation: 7,
              content: textFormFieldApp(
                  hintText: "enter_reply".tr,
                  controller: manageReviewController!.respondTextFieldController,
                  maxLines: 5,
                  style: AppTextStyle.tex17Regular(),
                  validator: (value) => manageReviewController!.validateRespond(value!)),
              actionsPadding: EdgeInsets.only(bottom: 5.h),
              actions: [
                Center(
                  child: buttonWithRadius10(
                    onPressed: onPressed,
                    child: Text(
                      buttonTitle,
                      style: AppTextStyle.tex17Medium(),
                    ),
                    color: AppColors.blue2,
                    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                  ),
                )
              ],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius10))),
        );
      },
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  Text _customerName(int index) {
    return Text(
      reviews[index].customer!.value.userName!,
      style: AppTextStyle.tex14Regular(),
    );
  }

  Future<Object?> _showDialogConfirm(int index) {
    return showAnimatedDialog(
      context: Get.context!,
      animationType: DialogTransitionType.slideFromTopFade,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "do_you_want_to_delete_this_feedback".tr,
            style: AppTextStyle.tex18Regular(),
          ),
          actions: [
            TextButton(
                onPressed: () => manageReviewController!.deleteRespond(reviews[index]),
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

   _avatarImage(int index) {
    return Skeleton(
      isLoading: reviews[index].customer!.value.avaUrl!.isEmpty,
      skeleton: SkeletonAvatar(
        style: SkeletonAvatarStyle(height: 28.h, width: 28.h, shape: BoxShape.circle),
      ),
      child: ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: AppImages.imageDefaultAvatar.getPNGImageAssets,
          image: reviews[index].customer!.value.avaUrl!,
          imageErrorBuilder: (context, error, stackTrace) => Image.asset(
            AppImages.imageDefaultAvatar.getPNGImageAssets,
            fit: BoxFit.cover,
            width: 30.h,
            height: 30.h,
          ),
          fit: BoxFit.cover,
          width: 30.h,
          height: 30.h,
        ),
      ),
    );
  }
}
