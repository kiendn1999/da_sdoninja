import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_radius.dart';
import 'package:da_sdoninja/app/constant/theme/app_shadows.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/partner_order_controller.dart';
import 'package:da_sdoninja/app/data/model/order_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/chip.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class PartnerOrderScreen extends StatefulWidget {
  late final String currentStoreID;
  PartnerOrderScreen({
    Key? key,
    required this.currentStoreID,
  }) : super(key: key);

  @override
  State<PartnerOrderScreen> createState() => _PartnerOrderScreenState();
}

class _PartnerOrderScreenState extends State<PartnerOrderScreen> {
  final _orderController = Get.find<PartnerOrderController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderController.getOrdersOfAllStageOfStore(widget.currentStoreID);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        margin: EdgeInsets.only(top: 15.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextChipChoice(
              _orderController,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                child: PageView.builder(
                  controller: _orderController.pageController,
                  itemCount: stageList.length,
                  onPageChanged: (index) {
                    _orderController.currentIndex = index;
                  },
                  itemBuilder: (context, stageIndex) {
                    return Obx(() => (stageIndex == 2 || stageIndex == 3)
                        ? _orderCheckingListView(_orderController.listOfListOrder[stageIndex], stageIndex)
                        : _orderListView(_orderController.listOfListOrder[stageIndex], stageIndex));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _orderCheckingListView(List<OrderModel> orders, int stageIndex) {
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
                        _customerNameAndChat(orders[index], enableSaveButton: true),
                        _listTileWithIconLeading(pathImage: AppImages.icStoreSelected, title: orders[index].customerAddress!),
                        _listTileWithIconLeading(
                            pathImage: AppImages.icClockSelected, iconColor: AppColors.black2, title: "request_date".trParams({"date": orders[index].requestDate!})),
                        _listTileWithTextField(pathImage: AppImages.icDevice, hintText: "device_name".tr),
                        _listTileWithTextField(
                            pathImage: AppImages.icBrokenCause,
                            hintText: "broken_cause".tr + "...",
                            crossAxisAlignment: CrossAxisAlignment.start,
                            maxLines: 3,
                            textAlign: TextAlign.start),
                        _listTileWithTextField(
                            pathImage: AppImages.icRepairCost,
                            hintText: "repair_cost".tr,
                            keyboardType: TextInputType.number,
                            unit: Container(
                              margin: EdgeInsets.only(left: 10.w),
                              child: Text(
                                "VND",
                                style: AppTextStyle.tex17Regular(),
                              ),
                            )),
                        _listTileWithTextField(
                            pathImage: AppImages.icRepairedDate,
                            hintText: "estimated_completion_time".tr,
                            keyboardType: TextInputType.number,
                            unit: Container(
                              margin: EdgeInsets.only(left: 10.w),
                              child: Text(
                                "day".tr,
                                style: AppTextStyle.tex17Regular(),
                              ),
                            )),
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
                        _customerNameAndChat(orders[index]),
                        _listTileWithIconLeading(pathImage: AppImages.icStoreSelected, title: orders[index].customerAddress!),
                        _listTileWithIconLeading(
                            pathImage: AppImages.icClockSelected, iconColor: AppColors.black2, title: "request_date".trParams({"date": orders[index].requestDate!})),
                        stageIndex == 1
                            ? const SizedBox.shrink()
                            : Column(
                                children: [
                                  _listTileWithIconLeading(pathImage: AppImages.icDevice, title: "device_name".tr + ": ${orders[index].deviceName}"),
                                  _listTileWithIconLeading(pathImage: AppImages.icBrokenCause, title: "broken_cause".tr + ": ${orders[index].brokenCause}"),
                                  _listTileWithIconLeading(pathImage: AppImages.icRepairCost, title: "repair_cost".tr + ": ${orders[index].repairCost} VND"),
                                  _listTileWithIconLeading(
                                      pathImage: AppImages.icRepairedDate,
                                      title: stageIndex < 5
                                          ? "estimated_completion_time".tr + ": ${orders[index].estimatedCompletionTime} " + "day".tr
                                          : "repair_completed_date".trParams({"date": orders[index].repairCompletedDate!})),
                                ],
                              ),
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
        return const SizedBox.shrink();
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _button(
              lable: "refuse".tr,
              color: AppColors.red,
              onPressed: () {},
            ),
            _button(
              lable: "accept".tr,
              color: AppColors.green,
              onPressed: () {},
            )
          ],
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
              lable: "notify_guests".tr,
              color: AppColors.green,
              onPressed: () {},
            ),
          ],
        );
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _button(
              lable: "cancel_repair".tr,
              color: AppColors.red,
              onPressed: () {},
            ),
            _button(
              lable: "notify_guests_again".tr,
              color: AppColors.green,
              onPressed: () {},
            ),
          ],
        );
      case 4:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _button(
              lable: "cancel_repair".tr,
              color: AppColors.red,
              onPressed: () {},
            ),
            _button(
              lable: "start_the_repair".tr,
              color: AppColors.green,
              onPressed: () {},
            ),
          ],
        );
      case 5:
        return _button(
          lable: "fixed".tr,
          color: AppColors.green,
          onPressed: () {},
        );
      case 6:
        return _button(
          lable: "received_money".tr,
          color: AppColors.green,
          onPressed: () {},
        );
      case 7:
        return const SizedBox.shrink();
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

  Row _customerNameAndChat(OrderModel order, {bool enableSaveButton = false}) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: AppImages.imageDefautAvatar.getPNGImageAssets,
                  image: order.customerAva!,
                  imageErrorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error,
                  ),
                  fit: BoxFit.cover,
                  width: 28.h,
                  height: 28.h,
                ),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: AutoSizeText(
                    order.customerName!,
                    maxLines: 1,
                    minFontSize: 17,
                    style: AppTextStyle.tex17Regular(),
                    overflowReplacement: SizedBox(
                      height: 25.h,
                      child: Marquee(
                        text: order.customerName!,
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
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.w),
          child: SvgPicture.asset(
            AppImages.icOrderChat.getSVGImageAssets,
            width: 22.w,
            height: 22.w,
          ),
        ),
        Visibility(
          visible: enableSaveButton,
          child: TextButton(
            onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Text(
              "save".tr,
              style: AppTextStyle.tex18Bold(color: AppColors.green),
            ),
            style: TextButton.styleFrom(
                padding: EdgeInsets.only(left: 15.w),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4)),
          ),
        )
      ],
    );
  }

  Widget _listTileWithTextField({
    required String pathImage,
    Color? iconColor,
    String? hintText,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.center,
    Widget unit = const SizedBox.shrink(),
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          SvgPicture.asset(
            pathImage.getSVGImageAssets,
            width: 22.w,
            height: 22.h,
            color: iconColor,
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 5.w),
                child: textFormFieldApp(
                    contentPadding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                    maxLines: maxLines,
                    textAlign: textAlign,
                    keyboardType: keyboardType,
                    hintText: hintText,
                    style: AppTextStyle.tex18Regular())),
          ),
          unit
        ],
      ),
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
