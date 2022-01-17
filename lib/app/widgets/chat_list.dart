import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/data/model/demo/chat_model.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  late List<ChatDemo> chatList = <ChatDemo>[];
  ChatList({required this.chatList});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.toNamed(Routes.conversation, arguments: index);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
              child: Row(
                children: [
                  Hero(
                    tag: index,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: AppImages.imageAvaShopDefault.getPNGImageAssets,
                        image: chatList[index].storeAva,
                        imageErrorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.error,
                        ),
                        fit: BoxFit.cover,
                        width: 45.h,
                        height: 45.h,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 8.w),
                      child: Column(
                        children: [
                          Text(
                            chatList[index].name,
                            style: AppTextStyle.tex18Regular(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 5.h),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      chatList[index].newMessage,
                                      style: AppTextStyle.tex15Regular(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    chatList[index].lastSentTime,
                                    style: AppTextStyle.tex15Regular(),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: chatList.length,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(
          height: 0,
          thickness: 1.5,
        ),
      ),
    );
  }
}
