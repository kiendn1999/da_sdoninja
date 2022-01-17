import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/function_controller/change_store_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/partner/partner_navigate_controller.dart';
import 'package:da_sdoninja/app/data/model/item_bottombar_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:da_sdoninja/app/screen/chat/partner_chat_screen.dart';
import 'package:da_sdoninja/app/screen/order/manage_order_screen.dart';
import 'package:da_sdoninja/app/screen/reviews/manage_review_screen.dart';
import 'package:da_sdoninja/app/screen/schedule/schedule_screen.dart';
import 'package:da_sdoninja/app/screen/store_info/my_store_screen.dart';
import 'package:da_sdoninja/app/widgets/bottombar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class PartnerNavigationFrame extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigateController = Get.find<PartnerNavigateController>();
  final _changeStoreController = Get.find<ChangeStoreController>(); 
  final _profileController = Get.find<ProfileController>(); 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(),
        endDrawer:  DrawerApp(),
        body: PageView(
          controller: _navigateController.pageController,
          children: [ManageOrderScreen(), ScheduleScreen(), ManageReviewScreen(), PartnerChatScreen(), MyStoreScreen()],
          onPageChanged: (index) {
            _navigateController.currentIndex = index;
          },
        ),
        floatingActionButton: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              alignment: _navigateController.currentIndex == 4 ? const AlignmentDirectional(1, 0.85) : const AlignmentDirectional(1, 1.5),
              child: Transform.scale(
                scale: 1.h,
                child: FloatingActionButton.small(
                  child: const Icon(Icons.edit_outlined),
                  onPressed: () {},
                ),
              ),
            )),
        bottomNavigationBar: _bottomItems(),
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
                  child: Obx(() => AutoSizeText(
                        _changeStoreController.storeSelected.storeName,
                        maxLines: 1,
                        minFontSize: 20,
                        style: AppTextStyle.tex18Medium(),
                        overflowReplacement: SizedBox(
                          height: 25.h,
                          child: Marquee(
                            text: _changeStoreController.storeSelected.storeName,
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
                child: FadeInImage.assetNetwork(
                  placeholder: AppImages.imageDefautAvatar.getPNGImageAssets,
                  image: _profileController.avaURL.toString(),
                  imageErrorBuilder: (context, error, stackTrace) =>  Image.asset(
                    AppImages.imageDefautAvatar.getPNGImageAssets,
                    fit: BoxFit.cover,
                    width: 35.h,
                    height: 35.h,
                  ),
                  fit: BoxFit.cover,
                  width: 35.h,
                  height: 35.h,
                ),
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
              ItemBottomBar(pathIconSelected: AppImages.icChatSelected, pathIconUnSelected: AppImages.icChat, lable: "message".tr),
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
