import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_radius.dart';
import 'package:da_sdoninja/app/constant/app_shadows.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/customer_order_controller.dart';
import 'package:da_sdoninja/app/data/model/demo/order_model.dart';
import 'package:da_sdoninja/app/utils/string_utils.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class OrderScreen extends StatelessWidget {
  final _orderController = Get.find<CustomerOrderController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextChipChoice(_orderController),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              child: PageView.builder(
                controller: _orderController.pageController,
                itemCount: 7,
                onPageChanged: (index) {
                  _orderController.currentIndex = index;
                },
                itemBuilder: (context, stageIndex) => _orderListView(stageIndex),
              ),
            ),
          )
        ],
      ),
    );
  }

  ListView _orderListView(int stageIndex) {
    return ListView.separated(
      itemCount: orderDemoList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return AppShadow.lightShadow(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius15)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                children: [
                  _storeNameAndChat(index),
                  _listTileWithIconLeading(
                      pathImage: AppImages.icClockSelected, iconColor: AppColors.black2, title: "request_date".trParams({"date": orderDemoList[index].requestDate})),
                  _listTileWithIconLeading(pathImage: AppImages.icDevice, title: "device_name".tr + ": ${orderDemoList[index].deviceName}"),
                  _listTileWithIconLeading(pathImage: AppImages.icBrokenCause, title: "broken_cause".tr + ": ${orderDemoList[index].brokenCause}"),
                  _listTileWithIconLeading(pathImage: AppImages.icRepairCost, title: "repair_cost".tr + ": ${orderDemoList[index].repairCost} VND"),
                  _listTileWithIconLeading(
                      pathImage: AppImages.icRepairedDate,
                      title: stageIndex < 4
                          ? "estimated_completion_time".tr + ": ${orderDemoList[index].repairedTime} " + "day".tr
                          : "repair_completed_date".trParams({"date": orderDemoList[index].repairedDate})),
                  _buttonInStages(stageIndex)
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        height: 8.h,
      ),
    );
  }

  Widget _buttonInStages(int stageIndex) {
    switch (stageIndex) {
      case 0:
        return _button(
          lable: "find_another_repair_shop".tr,
          color: AppColors.red,
          onPressed: () {},
        );
      case 1:
        return _button(
          lable: "cancel_repair".tr,
          color: AppColors.red,
          onPressed: () {},
        );
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _button(
              lable: "cancel_repair".tr,
              color: AppColors.red,
              onPressed: () {},
            ),
            _button(
              lable: "agree_to_repair".tr,
              color: AppColors.green,
              onPressed: () {},
            ),
          ],
        );
      case 3:
        return _button(
          lable: "cancel_repair".tr,
          color: AppColors.red,
          onPressed: () {},
        );
      case 4:
        return const SizedBox.shrink();
      case 5:
        return _button(
          lable: "pay".tr,
          color: AppColors.green,
          onPressed: () {},
        );
      case 6:
        return _button(
          lable: "review".tr,
          color: AppColors.orange,
          onPressed: () {},
        );
    }
    return const SizedBox.shrink();
  }

  _button({required String lable, required void Function() onPressed, Color? color}) {
    return buttonWithRadius10(
        onPressed: onPressed,
        child: Text(
          lable,
          style: AppTextStyle.tex16Medium(),
        ),
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        color: color);
  }

  Row _storeNameAndChat(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              StringUtils.getSVGImageAssets(AppImages.icStoreSelected),
              width: 22.w,
              height: 22.h,
              color: AppColors.pink,
            ),
            Container(
              margin: EdgeInsets.only(left: 5.w),
              constraints: BoxConstraints(maxWidth: 250.w),
              child: AutoSizeText(
                orderDemoList[index].storeName,
                maxLines: 1,
                minFontSize: 17,
                style: AppTextStyle.tex17Regular(),
                overflowReplacement: SizedBox(
                  height: 25.h,
                  child: Marquee(
                    text: orderDemoList[index].storeName,
                    scrollAxis: Axis.horizontal,
                    blankSpace: 10,
                    velocity: 100.0,
                    style: AppTextStyle.tex17Regular(),
                    pauseAfterRound: const Duration(seconds: 1),
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 14.w,
              child: const Icon(
                Icons.navigate_next_sharp,
              ),
            ),
          ],
        ),
        SvgPicture.asset(
          StringUtils.getSVGImageAssets(AppImages.icOrderChat),
          width: 22.w,
          height: 22.w,
        )
      ],
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
            StringUtils.getSVGImageAssets(pathImage),
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
