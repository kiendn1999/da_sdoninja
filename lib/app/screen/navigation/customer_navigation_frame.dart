import 'package:da_sdoninja/app/constant/string/key_id.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_radius.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/page_controller/common/profile_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/customer_navigate_controller.dart';
import 'package:da_sdoninja/app/controller/page_controller/customer/honme_custom_controller.dart';
import 'package:da_sdoninja/app/data/model/item_bottombar_model.dart';
import 'package:da_sdoninja/app/data/model/prediction.dart';
import 'package:da_sdoninja/app/extension/geocoding_extension.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/screen/home/home_customer_screen.dart';
import 'package:da_sdoninja/app/screen/order/customer_oder_screen.dart';
import 'package:da_sdoninja/app/widgets/autocomplete_place_textfield.dart';
import 'package:da_sdoninja/app/widgets/bottombar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomerNavigationFrame extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigateController = Get.find<CustomerNavigateController>();
  final _profileController = Get.find<ProfileController>();
  final _homeCustomerController = Get.find<HomeCustomerController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(),
        endDrawer: DrawerApp(),
        body: PageView(
          controller: _navigateController.pageController,
          children: [
            HomeCustomerScreen(),
            // MapScreen(),
            CustomerOrderScreen(),
            // CustomerChatScreen(),
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
                    child: GooglePlaceAutoCompleteTextField(
                        textEditingController: _homeCustomerController.addressTextFieldController,
                        googleAPIKey: googleMapAPIKey,
                        textStyle: AppTextStyle.tex14Regular(),
                        radius: AppRadius.radius90,
                        textAlign: TextAlign.center,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
                        hintText: "enter_your_location".tr,
                        debounceTime: 800, // default 600 ms, optional by default null is set
                        isLatLngRequired: true, // if you required coordinates from place detail
                        getPlaceDetailWithLatLng: (Prediction prediction) async {
                          _homeCustomerController.latitude = double.parse(prediction.lat!);
                          _homeCustomerController.longitude = double.parse(prediction.lng!);
                          _homeCustomerController.address = await GeocodingOnPosition.getAddressFromLatLng(_homeCustomerController.latitude, _homeCustomerController.longitude);
                          _homeCustomerController.getAllStore();
                        }, // this callback is called when isLatLngRequired is true
                        itmClick: (Prediction prediction) {
                          _homeCustomerController.addressTextFieldController.text = prediction.description!;
                          _homeCustomerController.addressTextFieldController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));
                          FocusManager.instance.primaryFocus?.unfocus();
                        }))),
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
                  image: _profileController.avaURL ?? "",
                  imageErrorBuilder: (context, error, stackTrace) => Image.asset(
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
              ItemBottomBar(pathIconSelected: AppImages.icHomeSelected, pathIconUnSelected: AppImages.icHome, lable: "home".tr),
              //ItemBottomBar(pathIconSelected: AppImages.icMapSelected, pathIconUnSelected: AppImages.icMap, lable: "map".tr),
              ItemBottomBar(pathIconSelected: AppImages.icOrdersSelected, pathIconUnSelected: AppImages.icOrders, lable: "repair_order".tr),
              // ItemBottomBar(pathIconSelected: AppImages.icChatSelected, pathIconUnSelected: AppImages.icChat, lable: "message".tr),
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
