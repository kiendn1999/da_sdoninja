import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/schedule_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ScheduleScreen extends StatefulWidget {
  late final String currentStoreID;
  ScheduleScreen({
    Key? key,
    required this.currentStoreID,
  }) : super(key: key);
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _scheduleController = Get.find<ScheduleController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scheduleController.getInfoStore(widget.currentStoreID);
  }

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
                  onTap: () async => await _scheduleController.addDateClose(widget.currentStoreID),
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
                      itemCount: _scheduleController.store.value.dayClosed!.length,
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
          _scheduleController.store.value.dayClosed![index],
          style: AppTextStyle.tex18Regular(),
        ),
        GestureDetector(
          onTap: () => _scheduleController.deleteDateClose(widget.currentStoreID, _scheduleController.store.value.dayClosed![index]),
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
                  onPressed: () async => await _scheduleController.updateOpenTime(widget.currentStoreID),
                  child: Obx(() => Text(
                        _scheduleController.startTime.format(context),
                        style: AppTextStyle.tex20Regular(color: AppColors.pink),
                      ))),
              Text(
                "-",
                style: AppTextStyle.tex20Regular(),
              ),
              TextButton(
                  onPressed: () async => await _scheduleController.updateCloseTime(widget.currentStoreID),
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
                    _scheduleController.openOrCloseStore(widget.currentStoreID, value);
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
