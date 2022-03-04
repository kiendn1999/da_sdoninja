// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_radius.dart';
import 'package:da_sdoninja/app/constant/theme/app_shadows.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/customer_order_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/honme_custom_controller.dart';
import 'package:da_sdoninja/app/data/model/order_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../controller/page_controller/customer/customer_navigate_controller.dart';

class CustomerOrderScreen extends StatefulWidget {
  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  final _orderController = Get.find<CustomerOrderController>();
  final CustomerNavigateController _customerNavigateController = Get.find();
  final HomeCustomerController _homeCustomerController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderController.getOrdersOfAllStageOfStore();
  }

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
                itemCount: stageList.length,
                onPageChanged: (index) {
                  _orderController.currentIndex = index;
                },
                itemBuilder: (context, stageIndex) => Obx(() => _orderListView(_orderController.listOfListOrder[stageIndex], stageIndex)),
              ),
            ),
          )
        ],
      ),
    );
  }

  _orderListView(List<OrderModel> orders, int stageIndex) {
    return orders.isEmpty
        ? Center(
            child: Image.asset(
              AppImages.imageLoad.getGIFImageAssets,
              width: Get.width,
              height: 400.h,
            ),
          )
        : ListView.separated(
            itemCount: orders.length,
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
                        _storeNameAndChat(orders[index]),
                        _listTileWithIconLeading(
                            pathImage: AppImages.icClockSelected, iconColor: AppColors.black2, title: "request_date".trParams({"date": orders[index].requestDate!})),
                        stageIndex == 1
                            ? const SizedBox.shrink()
                            : Column(
                                children: [
                                  _listTileWithIconLeading(pathImage: AppImages.icDevice, title: "device_name".tr + ":${orders[index].deviceName ?? "undefined".tr}"),
                                  _listTileWithIconLeading(pathImage: AppImages.icBrokenCause, title: "broken_cause".tr + ": ${orders[index].brokenCause ?? "undefined".tr}"),
                                  _listTileWithIconLeading(pathImage: AppImages.icRepairCost, title: "repair_cost".tr + ": ${orders[index].repairCost ?? "undefined".tr} VND"),
                                  _listTileWithIconLeading(
                                      pathImage: AppImages.icRepairedDate,
                                      title: stageIndex < 5
                                          ? "estimated_completion_time".tr + ": ${orders[index].estimatedCompletionTime ?? "undefined".tr} " + "day".tr
                                          : "repair_completed_date".trParams({"date": orders[index].repairCompletedDate!})),
                                ],
                              ),
                        _buttonInStages(stageIndex, orders[index])
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

  Widget _buttonInStages(int stageIndex, OrderModel order) {
    switch (stageIndex) {
      case 0:
        return _button(
          lable: "find_another_repair_shop".tr,
          color: AppColors.green,
          onPressed: () {
            _homeCustomerController.dropdownDeviceValue = order.storeType!;
            _homeCustomerController.getAllStore();
            _customerNavigateController.pageController.animateToPage(
              0,
              duration: const Duration(
                milliseconds: 200,
              ),
              curve: Curves.easeIn,
            );
          },
        );
      case 1:
        return _button(
          lable: "cancel_request".tr,
          color: AppColors.red,
          onPressed: () => _showDialogConfirm("are_you_sure_to_cancel_this_request".tr, order, "refuse"),
        );
      case 2:
        return _button(
          lable: "cancel_repair".tr,
          color: AppColors.red,
          onPressed: () => _showDialogConfirm("are_you_sure_to_cancel_this_repair".tr, order, stageList[0]),
        );
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _button(
              lable: "cancel_repair".tr,
              color: AppColors.red,
              onPressed: () => _showDialogConfirm("are_you_sure_to_cancel_this_repair".tr, order, stageList[0]),
            ),
            _button(
              lable: "agree_to_repair".tr,
              color: AppColors.green,
              onPressed: () => _showDialogConfirm("have_you_checked_carefully_will_you_agree_to_repair".tr, order, stageList[4]),
            ),
          ],
        );
      case 4:
        return _button(
          lable: "cancel_repair".tr,
          color: AppColors.red,
          onPressed: () => _showDialogConfirm("are_you_sure_to_cancel_this_repair".tr, order, stageList[0]),
        );
      case 5:
        return const SizedBox.shrink();
      case 6:
        return _button(
          lable: "pay".tr,
          color: AppColors.green,
          onPressed: () => _showDialogConfirm("are_you_sure_you_paid".tr, order, stageList[7]),
        );
      case 7:
        return order.isCommented!
            ? _button(
                lable: "edit_review".tr,
                color: AppColors.pink,
                onPressed: () => Get.toNamed(Routes.writeReview, arguments: order),
              )
            : _button(
                lable: "review".tr,
                color: AppColors.orange,
                onPressed: () => Get.toNamed(Routes.writeReview, arguments: order),
              );
    }
    return const SizedBox.shrink();
  }

  Future<Object?> _showDialogConfirm(String dialogTitle, OrderModel order, String stage) {
    return showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.slideFromTopFade,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            dialogTitle,
            style: AppTextStyle.tex18Regular(),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (stage == "refuse")
                    _orderController.deleteOrder(order);
                  else
                    _orderController.changeStageOfOrder(order, stage);
                  Get.back();
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

  Row _storeNameAndChat(OrderModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed(Routes.storeDetail, arguments: order.storeId),
          child: Row(
            children: [
              ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: AppImages.imageAvaShopDefault.getPNGImageAssets,
                  image: order.storeAva!,
                  imageErrorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error,
                  ),
                  fit: BoxFit.cover,
                  width: 28.h,
                  height: 28.h,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.w),
                constraints: BoxConstraints(maxWidth: 250.w),
                child: AutoSizeText(
                  order.storeName!,
                  maxLines: 1,
                  minFontSize: 17,
                  style: AppTextStyle.tex17Regular(),
                  overflowReplacement: SizedBox(
                    height: 25.h,
                    child: Marquee(
                      text: order.storeName!,
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
        ),
        SvgPicture.asset(
          AppImages.icOrderChat.getSVGImageAssets,
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
