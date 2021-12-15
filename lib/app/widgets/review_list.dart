import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_radius.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/data/model/demo/review_model.dart';
import 'package:da_sdoninja/app/utils/string_utils.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ReviewListCustomerSide extends StatelessWidget {
  late final List<ReviewDemo> reviewDemo;
  late final int itemCount;
  late final bool isManageReviewList;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final TextEditingController _replyTextFieldController = TextEditingController();

  ReviewListCustomerSide({required this.reviewDemo, required this.itemCount, this.physics, this.padding, this.isManageReviewList = false});

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
        return Row(
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
        );
      },
    );
  }

  Container _respondFromStore(int index, BuildContext context) {
    return Container(
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
                visible: this.isManageReviewList,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _replyTextFieldController.text = reviewDemoList[index].respondContent;
                        _showReplyDialog(context, buttonTitle: "save".tr, dialogTitle: "edit_reply_to".trParams({"name": reviewDemo[index].name}), onPressed: () {});
                      },
                      child: SvgPicture.asset(
                        StringUtils.getSVGImageAssets(AppImages.icPen),
                        width: 22.w,
                        height: 22.h,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40.w),
                      child: SvgPicture.asset(
                        StringUtils.getSVGImageAssets(AppImages.icTrash),
                        width: 22.w,
                        height: 22.h,
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
              reviewDemo[index].respondContent,
              style: AppTextStyle.tex14Regular(),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  Container _devieAndPrice(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Text(
        "device_price".trParams({
          "device": reviewDemo[index].device,
          "price": reviewDemo[index].price.toString(),
        }),
        style: AppTextStyle.tex14Regular(color: AppColors.blue2),
      ),
    );
  }

  Container _reviewContent(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Text(
        reviewDemo[index].content,
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
            TextSpan(text: reviewDemo[index].rate.toString()),
            WidgetSpan(
                child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 10.w),
              child: SvgPicture.asset(
                StringUtils.getSVGImageAssets(AppImages.icStarSelected),
                height: 17.h,
                width: 17.w,
              ),
            )),
            TextSpan(text: reviewDemo[index].date),
          ])),
          Visibility(
            visible: this.isManageReviewList && reviewDemo[index] == "",
            child: TextButton(
              onPressed: () => _showReplyDialog(context, buttonTitle: "send".tr, dialogTitle: "reply_to".trParams({"name": reviewDemo[index].name}), onPressed: () {}),
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
        return CustomDialogWidget(
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
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
            minWidth: 400,
            elevation: 7,
            content: textFormFieldApp(hintText: "enter_reply".tr, controller: _replyTextFieldController, maxLines: 5, style: AppTextStyle.tex17Regular()),
            bottomWidget: Align(
              alignment: Alignment.center,
              child: buttonWithRadius10(
                onPressed: onPressed,
                child: Text(
                  buttonTitle,
                  style: AppTextStyle.tex17Medium(),
                ),
                color: AppColors.blue2,
                margin: EdgeInsets.symmetric(vertical: 15.h),
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius10)));
      },
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  Text _customerName(int index) {
    return Text(
      reviewDemo[index].name,
      style: AppTextStyle.tex14Regular(),
    );
  }

  ClipOval _avatarImage(int index) {
    return ClipOval(
      child: FadeInImage.assetNetwork(
        placeholder: StringUtils.getPNGImageAssets(AppImages.imageDefautAvatar),
        image: reviewDemo[index].image,
        imageErrorBuilder: (context, error, stackTrace) => const Icon(
          Icons.error,
        ),
        fit: BoxFit.cover,
        width: 30.w,
        height: 30.w,
      ),
    );
  }
}
