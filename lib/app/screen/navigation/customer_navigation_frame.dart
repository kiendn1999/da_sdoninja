import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/constant/app_radius.dart';
import 'package:da_sdoninja/app/constant/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/customer_navigate_controller.dart';
import 'package:da_sdoninja/app/data/model/item_bottombar_model.dart';
import 'package:da_sdoninja/app/screen/chat/customer_chat_screen.dart';
import 'package:da_sdoninja/app/screen/home/home_customer_screen.dart';
import 'package:da_sdoninja/app/screen/map/map_screen.dart';
import 'package:da_sdoninja/app/screen/order/oder_screen.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/bottombar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomerNavigationFrame extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigateController = Get.find<CustomerNavigateController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(),
        endDrawer:  DrawerApp(),
        body: PageView(
          controller: _navigateController.pageController,
          children: [
            HomeCustomerScreen(),
            MapScreen(),
            OrderScreen(),
            CustomerChatScreen(),
          ],
          onPageChanged: (index) {
            _navigateController.currentIndex = index;
          },
        ),
        bottomNavigationBar: _bottomItems(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      centerTitle: true,
      toolbarHeight: 55.h,
      title: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.icLocation.getSVGImageAssets,
              width: 35.w,
              height: 35.h,
            ),
            Flexible(
                child: Container(
                    margin: EdgeInsets.only(left: 10.w),
                    child: textFormFieldApp(
                        style: AppTextStyle.tex14Regular(),
                        radius: AppRadius.radius90,
                        textAlign: TextAlign.center,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
                        hintText: "enter_your_location".tr))),
          ],
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
                  image: "https://thuthuatnhanh.com/wp-content/uploads/2019/06/anh-anime-nam.jpg",
                  imageErrorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error,
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
              ItemBottomBar(pathIconSelected: AppImages.icHomeSelected, pathIconUnSelected: AppImages.icHome, lable: "home".tr),
              ItemBottomBar(pathIconSelected: AppImages.icMapSelected, pathIconUnSelected: AppImages.icMap, lable: "map".tr),
              ItemBottomBar(pathIconSelected: AppImages.icOrdersSelected, pathIconUnSelected: AppImages.icOrders, lable: "repair_order".tr),
              ItemBottomBar(pathIconSelected: AppImages.icChatSelected, pathIconUnSelected: AppImages.icChat, lable: "message".tr),
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
