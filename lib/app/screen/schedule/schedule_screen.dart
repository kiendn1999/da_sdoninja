import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/schedule_controller.dart';
import 'package:da_sdoninja/app/extension/datetime_extension.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ScheduleScreen extends StatelessWidget {
  final _scheduleController = Get.find<ScheduleController>();

  late DateTime _date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _openStore(),
          _divider(),
          _storeOpenTime(context),
          _divider(),
          _closeDateAdd(context),
        ],
      ),
    );
  }

  _closeDateAdd(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 15.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "day_closed".tr,
                  style: AppTextStyle.tex20Regular(),
                ),
                GestureDetector(
                  onTap: () async {
                    _date = (await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      cancelText: "cancle".tr,
                      fieldLabelText: "enter_date".tr,
                      helpText: "select_closing_date".tr,
                      fieldHintText: "month_date_year".tr,
                      errorFormatText: "malformed_date".tr,
                      errorInvalidText: "out_of_range".tr,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    ))!;
                    _scheduleController.addClosedDate(_date);
                  },
                  child: Transform.scale(
                    scale: 1.h,
                    child: const Icon(
                      Icons.add_circle_outline,
                      size: 25,
                      color: AppColors.green,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 15.h),
                child: Obx(() => ListView.separated(
                      itemBuilder: (context, index) {
                        return _closeDateItem(index);
                      },
                      shrinkWrap: true,
                      itemCount: _scheduleController.closedDateList.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 15.h,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _closeDateItem(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _scheduleController.closedDateList[index].formatDateDefault,
          style: AppTextStyle.tex18Regular(),
        ),
        GestureDetector(
          onTap: () => _scheduleController.deleteClosedDate(_scheduleController.closedDateList[index]),
          child: SvgPicture.asset(
            AppImages.icTrash.getSVGImageAssets,
            width: 23.w,
            height: 23.h,
          ),
        )
      ],
    );
  }

  _storeOpenTime(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "open_time_title".tr,
            style: AppTextStyle.tex20Regular(),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () async {
                    _scheduleController.startTime = await _seclectAndShowTimePicker(
                      context,
                      helpText: "choose_opening_time".tr,
                      initialTime: _scheduleController.startTime,
                    );
                  },
                  child: Obx(() => Text(
                        _scheduleController.startTime.format(context),
                        style: AppTextStyle.tex20Regular(color: AppColors.pink),
                      ))),
              Text(
                "-",
                style: AppTextStyle.tex20Regular(),
              ),
              TextButton(
                  onPressed: () async {
                    _scheduleController.endTime = await _seclectAndShowTimePicker(
                      context,
                      helpText: "choose_closing_time".tr,
                      initialTime: _scheduleController.endTime,
                    );
                  },
                  child: Obx(() => Text(
                        _scheduleController.endTime.format(context),
                        style: AppTextStyle.tex20Regular(color: AppColors.blue2),
                      )))
            ],
          )
        ],
      ),
    );
  }

  Future<TimeOfDay> _seclectAndShowTimePicker(BuildContext context, {String? helpText, required TimeOfDay initialTime}) async {
    return (await showTimePicker(
      context: context,
      helpText: helpText,
      cancelText: "cancle".tr,
      errorInvalidText: "enter_a_valid_time".tr,
      hourLabelText: "hour".tr,
      minuteLabelText: "minute".tr,
      initialTime: initialTime,
    ))!;
  }

  Container _openStore() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "open_store".tr,
            style: AppTextStyle.tex20Regular(),
          ),
          Transform.scale(
              scale: 1.h,
              child: Obx(() => Switch(
                  value: _scheduleController.isStoreOpening,
                  onChanged: (value) {
                    _scheduleController.isStoreOpening = value;
                  })))
        ],
      ),
    );
  }

  Container _divider() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: const Divider(
        height: 0,
        thickness: 1.5,
      ),
    );
  }
}
