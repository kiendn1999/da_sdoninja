import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/change_store_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/partner_navigate_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/schedule_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/update_store_controller.dart';
import 'package:da_sdoninja/app/data/model/item_bottombar_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/screen/order/partner_order_screen.dart';
import 'package:da_sdoninja/app/screen/reviews/manage_review_screen.dart';
import 'package:da_sdoninja/app/screen/schedule/schedule_screen.dart';
import 'package:da_sdoninja/app/screen/store_info/my_store_screen.dart';
import 'package:da_sdoninja/app/widgets/bottombar.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../controller/page_controller/partner/manage_review_controller.dart';
import '../../controller/page_controller/partner/partner_order_controller.dart';

class PartnerNavigationFrame extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final PartnerNavigateController _navigateController = Get.find();
  final ChangeStoreController _changeStoreController = Get.find();
  final ProfileController _profileController = Get.find();
  final UpdateStoreController _updateStoreController = Get.find();
  final ManageReviewController _manageReviewController = Get.find();
  final ScheduleController _scheduleController = Get.find();
  final _orderController = Get.find<PartnerOrderController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(),
        endDrawer: DrawerApp(),
        body: Obx(() => _changeStoreController.stores.isEmpty
            ? _addNewStoreItem()
            : PageView(
                controller: _navigateController.pageController,
                children: [
                  PartnerOrderScreen(currentStoreID: _changeStoreController.currentStoreID.value),
                  ScheduleScreen(currentStoreID: _changeStoreController.currentStoreID.value),
                  ManageReviewScreen(
                    storeID: _changeStoreController.currentStoreID.value,
                  ),
                  // PartnerChatScreen(),
                  MyStoreScreen(
                    currentStore: _changeStoreController.currentStore.value,
                    controller: _updateStoreController,
                  )
                ],
                onPageChanged: (index) {
                  _navigateController.currentIndex = index;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              )),
        floatingActionButton: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              alignment: _navigateController.currentIndex == 3 ? const AlignmentDirectional(1, 0.85) : const AlignmentDirectional(1, 1.5),
              child: Transform.scale(
                scale: 1.h,
                child: FloatingActionButton.small(
                  child: Icon(_updateStoreController.isEdit ? Icons.done : Icons.edit_outlined),
                  onPressed: () => _updateStoreController.updateWithInfo(_changeStoreController.currentStore.value),
                ),
              ),
            )),
        bottomNavigationBar: _bottomItems(),
      ),
    );
  }

  Container _addNewStoreItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Image.asset(
            AppImages.imageLoad.getGIFImageAssets,
            width: Get.width,
            height: 350.h,
          ),
          Text(
            "you_dont_have_a_store_yet".tr,
            style: AppTextStyle.tex19Regular(),
            textAlign: TextAlign.center,
          ),
          buttonWithRadius10(
              onPressed: () => Get.toNamed(Routes.addNewStore),
              margin: EdgeInsets.only(top: 20.h),
              child: Text(
                "add_a_new_store".tr,
                style: AppTextStyle.tex18Medium(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h))
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 55.h,
      title: InkWell(
        onTap: () => Get.toNamed(Routes.manageStore),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            children: [
              SvgPicture.asset(
                AppImages.icStoreSelected.getSVGImageAssets,
                color: AppColors.white,
                width: 25.w,
                height: 25.h,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: Obx(() => _changeStoreController.stores.isEmpty
                      ? Text(
                          "summoning".tr,
                          style: AppTextStyle.tex18Medium(),
                        )
                      : AutoSizeText(
                          _changeStoreController.currentStore.value.storeName!,
                          maxLines: 1,
                          minFontSize: 20,
                          style: AppTextStyle.tex18Medium(),
                          overflowReplacement: SizedBox(
                            height: 25.h,
                            child: Marquee(
                              text: _changeStoreController.currentStore.value.storeName!,
                              scrollAxis: Axis.horizontal,
                              blankSpace: 10.0,
                              velocity: 100.0,
                              style: AppTextStyle.tex18Medium(),
                              pauseAfterRound: const Duration(seconds: 1),
                              accelerationDuration: const Duration(seconds: 1),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: const Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          ),
                        )),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w),
                child: SvgPicture.asset(
                  AppImages.icChervonRight.getSVGImageAssets,
                  width: 20.w,
                  height: 20.h,
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
            icon: AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipOval(
                child: Obx(() => FadeInImage.assetNetwork(
                      placeholder: AppImages.imageDefaultAvatar.getPNGImageAssets,
                      image: "${_profileController.avaURL}",
                      imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                        AppImages.imageDefaultAvatar.getPNGImageAssets,
                        fit: BoxFit.cover,
                        width: 35.h,
                        height: 35.h,
                      ),
                      fit: BoxFit.cover,
                      width: 35.h,
                      height: 35.h,
                    )),
              ),
            ))
      ],
    );
  }

  Widget _bottomItems() {
    return Obx(() => bottomBarHomeScreen(
            items: [
              ItemBottomBar(pathIconSelected: AppImages.icOrdersSelected, pathIconUnSelected: AppImages.icOrders, lable: "repair_order".tr),
              ItemBottomBar(pathIconSelected: AppImages.icClockSelected, pathIconUnSelected: AppImages.icClock, lable: "schedule".tr),
              ItemBottomBar(pathIconSelected: AppImages.icStarSelected, pathIconUnSelected: AppImages.icStar, lable: "reviews".tr),
              // ItemBottomBar(pathIconSelected: AppImages.icChatSelected, pathIconUnSelected: AppImages.icChat, lable: "message".tr),
              ItemBottomBar(pathIconSelected: AppImages.icStoreSelected, pathIconUnSelected: AppImages.icStore, lable: "my_store".tr),
            ],
            currentIndex: _navigateController.currentIndex,
            onTap: (index) {
              _navigateController.currentIndex = index;
              _navigateController.pageController.animateToPage(
                index,
                duration: const Duration(
                  milliseconds: 200,
                ),
                curve: Curves.easeIn,
              );
            }));
  }
}
