import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/change_store_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/partner_order_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/update_store_controller.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChangeStoreScreen extends StatelessWidget {
  final _changeStoreController = Get.find<ChangeStoreController>();
  final _partnerOrderController = Get.find<PartnerOrderController>();
  final UpdateStoreController _updateStoreController = Get.find();

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
      endDrawer: DrawerApp(),
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
      child: Obx(() => ListView.separated(
          itemBuilder: (context, index) => _storeItem(index),
          itemCount: _changeStoreController.stores.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Divider(
                height: 0,
                thickness: 1.5,
              ))),
    ));
  }

  Widget _storeItem(int index) {
    return InkWell(
      onTap: () async {
        _changeStoreController.changeStore(_changeStoreController.stores[index].id!);
        _partnerOrderController.getOrdersOfAllStageOfStore(_changeStoreController.stores[index].id);
        _updateStoreController.getDataToDisplayOnMyStoreScreen(_changeStoreController.stores[index]);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _changeStoreController.stores[index].storeName!,
                    style: AppTextStyle.tex18Medium(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10.h),
                      child: Text(
                        _changeStoreController.stores[index].address!,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.tex16Regular(),
                      ))
                ],
              ),
            ),
            Visibility(
              visible: _changeStoreController.currentStoreID == _changeStoreController.stores[index].id,
              child: Container(
                margin: EdgeInsets.only(left: 10.w),
                child: SvgPicture.asset(
                  AppImages.icDone.getSVGImageAssets,
                  width: 35.w,
                  height: 35.h,
                ),
              ),
            )
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
              itemList: storeTypes,
              contentPaddingHorizontal: 20.w,
              menuMaxHeight: 250.h,
              contentPaddingVertical: 7.h,
              value: _changeStoreController.dropdownDeviceValue,
              onChanged: (newValue) async {
                _changeStoreController.dropdownDeviceValue = newValue!;
                _changeStoreController.filterStoreType();
                _changeStoreController.getAllStore();
                _changeStoreController.stores.listen((stores) {
                   _partnerOrderController.getOrdersOfAllStageOfStore(stores[0].id);
                _updateStoreController.getDataToDisplayOnMyStoreScreen(stores[0]);
                });
               
              },
            ),
          )
        ],
      ),
    );
  }
}
