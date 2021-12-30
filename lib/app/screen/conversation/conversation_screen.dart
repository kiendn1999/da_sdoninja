import 'package:da_sdoninja/app/constant/app_colors.dart';
import 'package:da_sdoninja/app/constant/app_images.dart';
import 'package:da_sdoninja/app/data/model/demo/chat_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/appbar.dart';
import 'package:da_sdoninja/app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(context),
      endDrawer: const DrawerApp(),
    ));
  }

  AppBar _appBar(BuildContext context) {
    return appBarPopular(
        title: Row(
          children: [
            Hero(
              tag: Get.arguments,
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: AppImages.imageAvaShopDefault.getSVGImageAssets,
                  image: chatDemoList[0].storeAva,
                  imageErrorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error,
                  ),
                  fit: BoxFit.cover,
                  width: 40.h,
                  height: 40.h,
                ),
              ),
            ),
            Flexible(
                child: Container(
                    margin: EdgeInsets.only(left: 10.w),
                    child: Text(
                      chatDemoList[0].name,
                      overflow: TextOverflow.ellipsis,
                    )))
          ],
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                AppImages.icCall.getSVGImageAssets,
                width: 33.w,
                height: 33.h,
                color: context.isDarkMode ? AppColors.primaryLightModeColor : AppColors.primaryDarkModeColor,
              ))
        ]);
  }
}
