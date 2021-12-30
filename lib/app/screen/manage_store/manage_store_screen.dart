import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/function_controller/change_store_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/manage_store_controller.dart';
import 'package:da_sdoninja/app/data/model/demo/store_manage_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ManageStoreScreen extends StatelessWidget {
  final _manageStoreController = Get.find<ManageStoreController>();
  final _changeStoreController = Get.find<ChangeStoreController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBarPopular(centerTitle: true, title: Text("change_repair_store".tr), actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(Routes.addNewStore);
            },
            icon: Transform.scale(
                scale: 1.h,
                child: const Icon(
                  Icons.add,
                  size: 30,
                )))
      ]),
      endDrawer: const DrawerApp(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [_storeTypeFilter(), _storeList()],
        ),
      ),
    ));
  }

  Expanded _storeList() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 20.h),
      child: ListView.separated(
          itemBuilder: (context, index) => _storeItem(index),
          itemCount: storeManagerList.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Divider(
                height: 0,
                thickness: 1.5,
              )),
    ));
  }

  Widget _storeItem(int index) {
    return InkWell(
      onTap: () {
        _changeStoreController.changeStore(index, storeManagerList[index]);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        child: Row(
          children: [
            Flexible(
              child: Column(
                children: [
                  Text(
                    storeManagerList[index].storeName,
                    style: AppTextStyle.tex18Medium(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10.h),
                      child: Text(
                        storeManagerList[index].storeAddress,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.tex16Regular(),
                      ))
                ],
              ),
            ),
            Obx(() => Visibility(
                  visible: _changeStoreController.currendIndex == index,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.w),
                    child: SvgPicture.asset(
                      AppImages.icDone.getSVGImageAssets,
                      width: 35.w,
                      height: 35.h,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Container _storeTypeFilter() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              "repair_store_type".tr,
              style: AppTextStyle.tex18Regular(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 40.w),
            child: dropDownButton(
              width: 190.w,
              itemList: [
                "all_devices".tr,
                "motorcycle".tr,
                "car".tr,
                "computer".tr,
                "mobile_phone".tr,
                "electronic_device".tr,
                "refrigeration_device".tr,
                "electrical_equipment".tr
              ],
              contentPaddingHorizontal: 20.w,
              menuMaxHeight: 250.h,
              contentPaddingVertical: 7.h,
              value: _manageStoreController.dropdownDeviceValue,
              onChanged: (newValue) {
                _manageStoreController.dropdownDeviceValue = newValue!;
              },
            ),
          )
        ],
      ),
    );
  }
}
